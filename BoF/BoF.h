#pragma once

#include <opencv/cv.h>
#include <opencv/highgui.h>

class BoF {
protected:
	BoF() {}
	~BoF() {}

public:
	static void bofBySift(const cv::Mat& im, int blockSize, int gridStep, cv::Mat& result);
	static void sift(const cv::Mat& im_cropped, cv::Mat& sift);
	static void conv2(const cv::Mat& src, const cv::Mat& kernel, cv::Mat& dest);
	static cv::Mat gaussianFilter(float sigma, int size);
	static int sift_rot_id(float theta, int rotRes);
};

