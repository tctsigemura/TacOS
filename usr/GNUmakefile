#
# TacOS Source Code
#    Tokuyama kousen Educational Computer 16 bit Version
#
# Copyright (C) 2016 - 2020 by
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
#
# Makefile : usr ディレクトリ用の Makefile
#
# 2021.03.17         : tail を追加
# 2021.01.13         : screen を追加
# 2020.06.29         : tasm7 を追加
# 2019.11.14         : envtest env pwd printenv を追加
# 2019.03.13         : in out を追加
# 2018.11.24         : ar cp fsize mv を追加
# 2018.01.26         : lib ディレクトリを削除（C-- 標準ライブラリを用いる）
# 2016.01.07         : 初期バージョン
#
# $Id$
#
MAKEFLAGS=--no-print-directory

# サブディレクトリ
SUBDIRS:=ar cat cp dump echo edit fsize hello in ls mkdir mv out rm rmdir \
	shell touch ss sr spitest head env pwd printenv tasm7 sedit screen \
        tail version
# port

all :
	$(foreach dir, $(SUBDIRS), $(MAKE) --directory=$(dir); )

clean :
	$(foreach dir, $(SUBDIRS), $(MAKE) --directory=$(dir) clean; )
	rm -f *~

install :
	$(foreach dir, $(SUBDIRS), $(MAKE) --directory=$(dir) install; )
