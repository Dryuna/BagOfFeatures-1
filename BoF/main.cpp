/**
 * 道路網をパッチに分け、SIFTを使って特徴量ベクトルを抽出し、
 * K-meansでクラスタリングする。
 *
 * @author Gen Nishida
 * @version 1.0
 */

#include <iostream>
#include <opencv/cv.h>
#include <opencv/highgui.h>
#include <math.h>
#include "GraphUtil.h"
#include "Util.h"
#include "BoF.h"

int main(int argc, char *argv[]) {
	if (argc < 5) {
		std::cerr << "Usage: BoF <directory> <block size> <grid step> <num cluster>" << std::endl;
		return 1;
	}
	
	QString dirname = argv[1];
	int blockSize = atoi(argv[2]);
	int gridStep = atoi(argv[3]);
	int numCluster = atoi(argv[4]);
	int blockSizeEx = blockSize + 2;

	std::vector<QString> jpg = Util::GetFileList((dirname + "/*.jpg").toUtf8().data());
	std::vector<cv::Mat> sift_vec;
	sift_vec.resize(jpg.size());

	// hconcatのテスト
	/*
	std::vector<cv::Mat> imlist;
	imlist.resize(3);
	imlist[0] = cv::imread("roads/london0.jpg", 0);
	imlist[1] = cv::imread("roads/london1.jpg", 0);
	imlist[2] = cv::imread("roads/london1.jpg", 0);
	cv::Mat im3;
	cv::hconcat(imlist, im3);
	cv::imwrite("im3.jpg", im3);

	// conv2のテスト
	cv::Mat kernel = (cv::Mat_<float>(3, 1) << 1, 0, -1);
	cv::Mat im = (cv::Mat_<float>(3, 3) << 1, 2, 3, 4, 5, 6, 7, 8, 9);
	cv::Mat result(1, 3, CV_32F);
	//BoF::conv2(im, kernel, result);
	cv::Mat im2;
	cv::multiply(im, im, im2);
	std::cout << im2 << std::endl;
	*/

	for (int i = 0; i < jpg.size(); i++) {
		std::cout << jpg[i].toUtf8().data() << std::endl;

		cv::Mat im = cv::imread((dirname + "/" + jpg[i]).toUtf8().data(), 0);

		// 各画像について、SIFT特徴量行列を計算する
		BoF::bofBySift(im, blockSize, gridStep, sift_vec[i]);
	}

	// SIFT特徴量行列を、１つの [ブロック数] x 128 行列にする
	cv::Mat sift_vecs;
	cv::vconcat(sift_vec, sift_vecs);

	// K-meansクラスタリング
	cv::Mat idx;
	cv::Mat centers;
	cv::kmeans(sift_vecs, numCluster, idx, cv::TermCriteria(CV_TERMCRIT_ITER|CV_TERMCRIT_EPS, 10000, 0.0001), 10, cv::KMEANS_PP_CENTERS, centers);

	// クラス毎に、画像パッチを保存する
	int idx_count = 0;
	for (int i = 0; i < jpg.size(); i++) {
		std::cout << jpg[i].toUtf8().data() << std::endl;

		cv::Mat im = cv::imread((dirname + "/" + jpg[i]).toUtf8().data(), 0);

		int count = 0;
		for (int v = blockSize; v <= im.rows - blockSize; v += gridStep) {
			for (int u = blockSize; u <= im.cols - blockSize; u += gridStep) {
				cv::Rect roi(u - blockSizeEx / 2, v - blockSizeEx / 2, blockSizeEx, blockSizeEx);
				cv::Mat im_cropped = im(roi);

				cv::imwrite(QString("results/%1_%2_%3.jpg").arg(idx.at<int>(idx_count, 0)).arg(jpg[i]).arg(count).toUtf8().data(), im_cropped);

				count++;
				idx_count++;
			}
		}
	}
}