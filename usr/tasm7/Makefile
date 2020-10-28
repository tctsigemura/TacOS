##
# C-- 言語から a.out、.exe、 .v ファイルを作る手順
#

#UNIXならallにTasm7を追加する

all: Tasm7.exe # Tasm7 Tasm7.v

# UNIX, Mac の a.out へ変換
Tasm7: Tasm7.cmm Assemble.hmm Error.cmm Error.hmm SymTbl.cmm SymTbl.hmm Lexical.cmm Lexical.hmm Pass1.cmm Pass1.hmm OperationTbl.cmm OperationTbl.hmm Util.cmm Util.hmm Pass2.cmm Pass2.hmm Editor.cmm Editor.hmm
	cm2c -o Tasm7 Tasm7.cmm Error.cmm SymTbl.cmm Lexical.cmm Pass1.cmm OperationTbl.cmm Util.cmm Pass2.cmm Editor.cmm

# TacOS の実行形式を作る
Tasm7.exe: Tasm7.cmm Assemble.hmm Error.cmm Error.hmm SymTbl.cmm SymTbl.hmm Lexical.cmm Lexical.hmm Pass1.cmm Pass1.hmm OperationTbl.cmm OperationTbl.hmm Util.cmm Util.hmm Pass2.cmm Pass2.hmm Editor.cmm Editor.hmm
	cm2e -o Tasm7.exe -s 1000 Tasm7.cmm Error.cmm SymTbl.cmm Lexical.cmm Pass1.cmm OperationTbl.cmm Util.cmm Pass2.cmm Editor.cmm

# C--コンパイラの中間言語に変換する
Tasm7.v: Tasm7.cmm
	cm2v Tasm7.cmm

clean:
	rm -f Tasm7 Tasm7.c Tasm7.s Tasm7.v *.lst *.sym *.map *.o *.exe *~
