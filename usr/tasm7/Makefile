##
# C-- 言語から .exe ファイルを作る手順
#

all: Tasm7.exe

# TacOS の実行形式を作る
Tasm7.exe: Tasm7.cmm Assemble.hmm Error.cmm Error.hmm SymTbl.cmm SymTbl.hmm Lexical.cmm Lexical.hmm Pass1.cmm Pass1.hmm OperationTbl.cmm OperationTbl.hmm Util.cmm Util.hmm Pass2.cmm Pass2.hmm Editor.cmm Editor.hmm
	cm2e -o Tasm7.exe -s 1000 Tasm7.cmm Error.cmm Symtbl.cmm Lexical.cmm Pass1.cmm OperationTbl.cmm Util.cmm Pass2.cmm Editor.cmm

clean:
	rm -f ${NAME} *.o *.lst *.sym *.exe *.map *~
