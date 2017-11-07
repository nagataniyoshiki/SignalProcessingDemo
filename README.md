# 神戸高専 電子工学科 サポートスクリプト / Support Scripts for the Students in Kobe City College of Technology


## 概要 / Outline

神戸高専 電子工学科5年 電子応用（選択科目）の理解を助けるためのスクリプトを公開しています。活用して下さい。
Matlab & Octave (.m) および Scilab (.sci) 対応（のはず）です。また， .m スクリプトには日本語版（ *_ja.m ）も用意しています。  
You may find scripts for supporting students who learn Applied Electronic Engineering Class in Kobe City College of Technology. All scripts are compatible with Matlab/Octave (.m) and Scilab (.sci) platforms.

### Sinc関数の畳み込みによるアップサンプリングのデモ / Sinc Interpolation Demo [sinc_demo.m/.sci]
離散信号のアップサンプリング（Sinc補間）を，加算するSinc波を全て表示することで視覚的に理解します。  
A demo program for visually understanding the sinc interpolation for upsampling a descrete signal by showing all sinc functions which will be summed up.

### 離散フーリエ変換（DFT）のデモ / DFT Demo [dft_demo.m/.sci]
離散フーリエ変換のプロセスを，積分するcos波およびsin波を全て表示することで視覚的に理解します。  
A demo program for visually understanding the process of the Descrete Fourier Transform showing all sinusoidal waves which will be integrated.

### ゼロ詰めをおこなった場合の離散フーリエ変換のデモ / Zero Padding Demo [zeropadding_demo.m/.sci]
ゼロ詰めをおこなった場合の離散フーリエ変換を波形をスペクトルを表示することで視覚的に理解します。  
A demo program for visually understanding the Descrete Fourier Transform with zero padding by showing the waveform and the spectrum.

### 離散フーリエ変換の窓関数のデモ / FFT Window Demo [window_demo.m/.sci]
離散フーリエ変換の窓関数の影響を，波形とそのスペクトル，および窓関数のスペクトルを表示することで視覚的に理解します。  
A demo program for visually understanding the effect of the window function for the Descrete Fourier Transform by showing the waveform, its spectrum, and the spectrum of the window function.

### アベレージングによるノイズ除去のデモ / Averaging Demo on Improving SNR [averaging_SNR_demo.m/.sci]
アベレージング（加算平均）によって繰り返し信号に混入したノイズが除去される様子を視覚的に理解します。  
A demo program for visually understanding the behavior of the averaging technique which reduces the noise added to a repetition signal.

### アベレージングによる量子化精度向上のデモ / Averaging Demo on Quantization Resolution [averaging_quantization_demo.m/.sci]
ノイズを意図的に付加した信号のアベレージング（加算平均）によってA/Dコンバータの量子化精度以上の情報が得られる様子を視覚的に理解します。  
A demo program for visually understanding the behavior of the averaging technique wich derives extra information beyond the quantization resolution of the A/D converter by adding noise by design.


## ライセンス / License

Contents are licensed under [CC BY-SA 3.0](http://creativecommons.org/licenses/by-sa/3.0/) (Creative Commons Attribution-ShareAlike 3.0 Unported License).  
これらのコンテンツはクリエイティブコモンズ [CC BY-SA 3.0](http://creativecommons.org/licenses/by-sa/3.0/) ライセンスの元で公開しています。


***


長谷 芳樹 （神戸市立工業高等専門学校）  
Yoshiki NAGATANI, Kobe City College of Technology, Japan  
 https://ultrasonics.jp/nagatani/  
 https://twitter.com/nagataniyoshiki
