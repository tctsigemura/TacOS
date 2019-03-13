# TacOS
Tokuyama advanced educational computer's Operating System
---

TacOSは徳山高専で開発した教育用のオペレーティングシステムです。
受講者にソースコードを読んでもらうことを第１の目的にしています。
ソースコードとして読めるだけでなく実機で動作する
本物のオペレーティングシステムでもあります。

## 動作環境
TacOSはTaC(Tokuyama Advanced Educational Computer)と
呼ばれる実機上で動作します。
TaCはFPGA(Xilinx Spartan-6)に組み込まれた原始的なパーソナルコンピュータです。
USBまたはBlutooth経由のシリアル接続で端末を接続し，
ハードディスク代わりのマイクロSDカードを準備することで
1980年代前半の8bitパソコン程度（？）の能力を発揮します。

TaCのCPUは、49MHzで動作する、
メモリ空間64KiBのオリジナル16bitCPUです。
8bit版のTeCとアセンブリ言語レベルではそっくりになっているので、
TeCで機械語の勉強をした人はすぐに理解することが可能です。

TaCはマイクロSDカードにインストールしたTacOSをブートすることが可能です。

### TaCの入手
TaCは[竹上電気商会](http://www.e-takegami.jp/)で
販売しているTeC7の16bitモードのことです。
TeC7に
[最新の設計データ](https://github.com/tctsigemura/TeC7)
を書き込む必要があります。

### TaCの設計図
VHDLで記述されたTaCの設計図（？）は、
[tctsigemura/TeC7](https://github.com/tctsigemura/TeC7)で公開しています。

## できること
### オペレーティングシステムの勉強
公開中のOSの教科書
（[オペレーティングシステム](https://github.com/tctsigemura/OSTextBook)）
の中で、TacOSのソースコードが実装例として参照されています。

### ソースコードの勉強
TacOSのソースコードを読んで勉強することができます。
TacOSは、
マイクロカーネル方式の読みやすい構造を持っています。
TacOSは、
[C--言語](https://github.com/tctsigemura/C--)で
記述されています。
ビルドするとメモリマップがファイルに出力されます。
TaCのコンソールパネルからブレークポイントを設定したり、
ステップ実行させたりしながらOSの内部をトレースできます。

### アプリケーションの実行
TacOSのアプリケーションプログラムは
[C--言語](https://github.com/tctsigemura/C--)で記述します。
C--言語の開発環境はMacやLinuxで動作します。
C--言語で記述したアプリケーションは、
FAT16マイクロSDカードに書き込んでTaCで実行することができます。

### アプリケーションの開発
近い将来、
[C--言語](https://github.com/tctsigemura/C--)の
言語処理系がTacOSに移植される予定です。
移植が完了したら、TaC上でTaCのアプリケーションを開発する
ことが可能になります。
