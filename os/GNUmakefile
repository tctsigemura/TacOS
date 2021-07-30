#
# TacOS Source Code
#    Tokuyama kousen Educational Computer 16 bit Version
#
# Copyright (C) 2011-2020 by
#                      Dept. of Computer Science and Electronic Engineering,
#                      Tokuyama College of Technology, JAPAN
#
#   上記著作権者は，Free Software Foundation によって公開されている GNU 一般公
# 衆利用許諾契約書バージョン２に記述されている条件を満たす場合に限り，本ソース
# コード(本ソースコードを改変したものを含む．以下同様)を使用・複製・改変・再配
# 布することを無償で許諾する．
#
#   本ソースコードは＊全くの無保証＊で提供されるものである。上記著作権者および
# 関連機関・個人は本ソースコードに関して，その適用可能性も含めて，いかなる保証
# も行わない．また，本ソースコードの利用により直接的または間接的に生じたいかな
# る損害に関しても，その責任を負わない．

#
# GNUmakefile
#
# 2020.09.06 : kernel.bin と kernel0.bin を同時に作るように変更
# 2020.08.15 : 組み込み版に対応
# 2019.06.13 : VGA, PS2を削除
# 2018.11.12 : SIO版の作業開始
# 2015.08.31 : c-- コンパイラの -K オプションに対応(重村)
# 2015.06.04 : SUBDIRS に tty を追加
# 2014.05.07 : 村田開発開始
# 2013.01.04 : kernel.map を作成するように変更
# 2012.03.02 : TaC7 用に書き換え + boot.bin + sioboot.bin を追加
# 2011.11.27 : MacOS X に対応(cpp 問題)
# 2011.05.11 : 初期バージョン

# デバッグ
DEBUG=DEBUG=1

#　ディレクトリを移動する際のログを出力しない
MAKEFLAGS=--no-print-directory

# make 対象のサブディレクトリ crt0 が含まれる util を最初にすること！！
GENSUBDIRS:=util kernel fs sio tty mm pm     # 汎用カーネル
EMBSUBDIRS:=util kernel fs mm app            # 組み込みカーネル

# OBJS に SUBDIRS で生成された各 mod.o ファイルをディレクトリパス付きで代入
GENOBJS=$(foreach dir, $(GENSUBDIRS), $(dir)/mod.o )
EMBOBJS=$(foreach dir, $(EMBSUBDIRS), $(dir)/mod.o )


# clean を実行した後 kernel.bin を実行
all : kernel.bin kernel0.bin

clean : clean1 clean0

# ここでは以下を行う
# (1) 各サブディレクトリで make を実行し
# (2) 全ての mod.o を結合して kernel.o を生成
# (3) kernel.o のサイズを表示
# (4) kernel.o を 0x0000 番地にロードした kernel.bin を生成
# (5) メモリマップを kernel.map に格納
kernel.bin : clean1
	$(foreach dir,$(GENSUBDIRS),${MAKE} ${DEBUG} --directory=$(dir);)
	ld-- kernel.o ${GENOBJS} > kernel.sym
	size-- kernel.o
	objbin-- 0x0000 kernel.bin kernel.o | sort --key=1 > kernel.map

# 組み込みアプリ用のカーネルを作る
kernel0.bin : clean0
	$(foreach dir,$(EMBSUBDIRS),${MAKE} ${DEBUG} EMBEDDED=1 --directory=$(dir);)
	ld-- kernel0.o ${EMBOBJS} > kernel0.sym
	size-- kernel0.o
	objbin-- 0x0000 kernel0.bin kernel0.o | sort --key=1 > kernel0.map

# 
clean1 :
	rm -f kernel.bin kernel.map kernel.o kernel.sym *~
	$(foreach dir,$(GENSUBDIRS),$(MAKE) --directory=$(dir) clean;)

clean0 :
	rm -f kernel0.bin kernel0.map kernel0.o kernel0.sym *~
	$(foreach dir,$(EMBSUBDIRS),$(MAKE) --directory=$(dir) clean;)
