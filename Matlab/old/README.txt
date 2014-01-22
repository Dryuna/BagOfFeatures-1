Bag of Featuresのテスト

■ 準備
roads/londonディレクトリとroads/parisディレクトリに、それぞれの道路網の画像を入れておく。

■ 使い方
Octave> bof_grid

しばらく待つと、同じディレクトリに、以下の２つのファイルが作成される。
london.txt
paris.txt

この２つのファイルをつなげて、training.txtという名前で保存し、以下のコマンドを実行する。

> C:\libsvm-3.17\windows\svm-train.exe -s 1 -v 100 training.txt


★ 道路網のK-meansによるクラスタリング実験

■ 準備
roads/londonディレクトリとroads/parisディレクトリに、それぞれの道路網の画像を入れておく。

■ 使い方
Octave> pkg load statistics
Octave> test

標準出力に、修理された画像ファイル名が１つずつ表示される。
最後に、resultsディレクトリ以下に、クラスタ毎にフォルダが作成され、その中に属する画像ファイルが保存される。