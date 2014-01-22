#include "BoF.h"
#include <vector>
#include <math.h>

#ifndef M_PI
#define M_PI	3.141592653
#endif

#define SQR(x)	((x) * (x))

/**
 * 与えられた画像について、各セルのSIFT特徴量ベクトルをつなげて、１つのBag of Featuresとする。
 */
void BoF::bofBySift(const cv::Mat& im, int blockSize, int gridStep, cv::Mat& result) {
	int blockSizeEx = blockSize + 2;

	// 各セルのSIFT特徴量ベクトルを計算する
	std::vector<cv::Mat> sift_vec;

	int count = 0;
	for (int v = blockSize; v <= im.rows - blockSize; v += gridStep) {
		for (int u = blockSize; u <= im.cols - blockSize; u += gridStep) {
			cv::Rect roi(u - blockSizeEx / 2, v - blockSizeEx / 2, blockSizeEx, blockSizeEx);
			cv::Mat im_cropped = im(roi);

			sift_vec.push_back(cv::Mat());
			BoF::sift(im_cropped, sift_vec[count++]);
		}
	}

	// 各SIFT特徴量(1x128行列)を縦につなげて、[セル数] x 128 の行列にする
	cv::vconcat(sift_vec, result);
}

/**
 * 与えられた画像パッチに基づいて、SIFT特徴量ベクトルを計算する。
 * 画像パッチは、正方形であることが前提。
 */
void BoF::sift(const cv::Mat& im, cv::Mat& sift) {
	
	int blockSizeEx = im.rows;
	int blockSize = blockSizeEx - 2;
	float sigma = (float)blockSize / 6.0f;

	cv::Mat G = gaussianFilter(sigma, blockSizeEx);

	cv::Mat kernel_x = (cv::Mat_<float>(1, 3) << 1, 0, -1);
	cv::Mat kernel_y = (cv::Mat_<float>(3, 1) << 1, 0, -1);
	cv::Mat dx, dy;
	
	cv::Mat imF;
	im.convertTo(imF, CV_32F);
	conv2(imF, kernel_x, dx);
	conv2(imF, kernel_y, dy);

	// 勾配強度と勾配方向を計算
	cv::Mat mag(im.size(), CV_32F);
	cv::Mat theta(im.size(), CV_32F);
	for (int i = 0; i < im.rows; i++) {
		for (int j = 0; j < im.cols; j++) {
			if (i == 0 || j == 0 || i == im.rows - 1 || j == im.cols - 1) {
				mag.at<float>(i, j) = 0;
				theta.at<float>(i, j) = 0;
			} else {
				mag.at<float>(i, j) = sqrtf(SQR(dx.at<float>(i, j)) + SQR(dy.at<float>(i, j)));
				theta.at<float>(i, j) = atan2(dy.at<float>(i, j), dx.at<float>(i, j));
			}
		}
	}

	// 各セルの勾配ベクトルを8次元ヒストグラムに入れていく
	int cellSize = 4;
	int rotRes = 8;
	std::vector<cv::Mat> hist_array;
	hist_array.resize(cellSize * cellSize);
	for (int i = 0; i < cellSize; i++) {
	    for (int j = 0; j < cellSize; j++) {
			hist_array[i * cellSize + j] = cv::Mat::zeros(1, rotRes, CV_32F);

			for (int m = (float)i * (float)blockSize / (float)cellSize; m < ceilf((float)(i + 1) * (float)blockSize / (float)cellSize); m++) {
				for (int n = (float)j * (float)blockSize / (float)cellSize; n < ceilf((float)(j + 1) * (float)blockSize / (float)cellSize); n++) {
					float a = mag.at<float>(m, n);
					float b = G.at<float>(m, n);
					float c = theta.at<float>(m, n);
					hist_array[i * cellSize + j].at<float>(0, sift_rot_id(theta.at<float>(m, n), rotRes)) += mag.at<float>(m, n) * G.at<float>(m, n);
				}
			}
		}
	}

	// 4x4セルに入っている8次元ヒストグラムをつなげて、128次元ベクトルにする
	cv::hconcat(hist_array, sift);
}

/**
 * Matlabのconv2('same')相当
 * destは、float型の行列である。
 */
void BoF::conv2(const cv::Mat& src, const cv::Mat& kernel, cv::Mat& dest) {
	// srcの周囲に、輝度値0のボーダーを追加する
	cv::Mat src2;
	const int additionalRows = kernel.rows-1, additionalCols = kernel.cols-1;
	cv::copyMakeBorder(src, src2, (additionalRows+1)/2, additionalRows/2, (additionalCols+1)/2, additionalCols/2, cv::BORDER_CONSTANT, cv::Scalar(0));

	// kernelを構築（filter2Dでは、matrixを上下左右反転させる必要がある）
	cv::Mat k;
	cv::flip(kernel, k, 0);
	cv::flip(k, k, 1);
	cv::Point anchor(kernel.cols - kernel.cols/2 - 1, kernel.rows - kernel.rows/2 - 1);
	cv::filter2D(src2, dest, src.depth(), k, anchor, 0);

	// srcと同じサイズの行列になるよう、中心部分を取り出す
	dest = dest.colRange((int)((kernel.cols-1)/2), (int)((kernel.cols-1)/2) + src.cols);
	dest = dest.rowRange((kernel.rows-1)/2, (kernel.rows-1)/2 + src.rows);
}

/**
 * 指定されたサイズのガウシンアンフィルタを作成する。
 */
cv::Mat BoF::gaussianFilter(float sigma, int size) {
	cv::Mat_<float> G(size, size);
	for (int i = 0; i < size; i++) {
		for (int j = 1; j < size; j++) {
			G(i,j) = exp(-1 * (SQR(i-(size+1)/2) + SQR(j-(size+1)/2)) / (2 * SQR(sigma))) / (2 * M_PI * SQR(sigma));
		}
	}

	return G;
}

int BoF::sift_rot_id(float theta, int rotRes) {
	if (-M_PI/8 <= theta && theta < M_PI/8) return 0;
	else if (M_PI/8 <= theta && theta < 3*M_PI/8) return 1;
	else if (3*M_PI/8 <= theta && theta < 5*M_PI/8) return 2;
	else if (5*M_PI/8 <= theta && theta < 7*M_PI/8) return 3;
	else if (7*M_PI/8 <= theta || theta < -7*M_PI/8) return 4;
	else if (-7*M_PI/8 <= theta && theta < -5*M_PI/8) return 5;
	else if (-5*M_PI/8 <= theta && theta < -3*M_PI/8) return 6;
	else return 7;
}
