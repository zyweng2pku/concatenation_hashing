
# Concatenation hashing: A relative position preserving method for learning binary codes
This repository contains the matlab code for the unsupervised hashing approach proposed in our paper:
"Concatenation hashing: A relative position preserving method for learning binary codes". Zhenyu Weng, Yuesheng Zhu. Pattern Recognition, 2020.



## Reference ##
Please cite:
```
@article{WENG2020107151,
title = "Concatenation hashing: A relative position preserving method for learning binary codes",
journal = "Pattern Recognition",
volume = "100",
pages = "107151",
year = "2020",
author = "Zhenyu Weng and Yuesheng Zhu",
keywords = "Unsupervised hashing, Approximate nearest neighbor search, Clustering",
abstract = "Hashing methods perform the efficient nearest neighbor search by mapping high-dimensional data to binary codes. Compared to projection-based hashing methods, hashing methods that adopt the clustering technique can encode the complex relationship of the data into binary codes. However, their search performance is affected by the boundary of the cluster. Two similar data points may be assigned to two different clusters and then encoded into two much different binary codes. In this paper, we propose a new hashing method based on the clustering technique and it can alleviate the effect from the cluster boundary. It is from an observation that the relative positions of any two close data points to each cluster center are close. An alternating optimization is developed to simultaneously discover the cluster structures of the data and learn the hash functions to preserve the relative positions of the data to each cluster center. To integrate the information in each cluster, the corresponding binary code of each data point is obtained by concatenating the substrings learnt by the hash functions in each cluster. The experiments show that our method is competitive to or better than the state-of-the-art hashing methods."
}
```

## Acknowledgement ##
A part of the code is borrowed from [Yunchao Gong](http://www.unc.edu/~yunchao/code/smallcode.zip). Thanks for their wonderful works.

## Contact ##
- Zhenyu Weng (Peking University)
- wzytumbler@pku.edu.cn

