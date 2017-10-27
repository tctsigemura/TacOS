; 
;  TacOS Source Code
;     Tokuyama kousen Advanced educational Computer.
; 
;  Copyright (C) 2011 - 2016 by
;                       Dept. of Computer Science and Electronic Engineering,
;                       Tokuyama College of Technology, JAPAN
; 
;    上記著作権者は，Free Software Foundation によって公開されている GNU 一般公
;  衆利用許諾契約書バージョン２に記述されている条件を満たす場合に限り，本ソース
;  コード(本ソースコードを改変したものを含む．以下同様)を使用・複製・改変・再配
;  布することを無償で許諾する．
; 
;    本ソースコードは＊全くの無保証＊で提供されるものである。上記著作権者および
;  関連機関・個人は本ソースコードに関して，その適用可能性も含めて，いかなる保証
;  も行わない．また，本ソースコードの利用により直接的または間接的に生じたいかな
;  る損害に関しても，その責任を負わない．
; 
;

; 
; kernel/dispatcher.s : ディスパッチャ
;
; 2017.10.27 : ルーチン名を変更(_dispatch -> _yield, _startProc -> _dispatch)
; 2015.11.17 : PCB の項目を追加したため、[next]と[magic]へのポインタをずらした
; 2015.09.02 : ソースコードを清書(重村)
; 2015.04.02 : PCB の項目を追加したため、[next]と[magic]へのポインタをずらした
; 2015.03.10 : PCB の項目を削ったたため、[next]と[magic]へのポインタをずらした
; 2015.02.25 : PCB の項目を追加したため、[next]と[magic]へのポインタをずらした
; 2014.05.07 : 村田開発開始、ファイル名を変更(disp.s -> dispathcer.s)
; 2013.03.07 : selProc を C-- からアセンブラに変更
; 2013.03.05 : C-- に依存した保存しないレジスタルールを撤回
; 2013.01.22 : スタック上のレジスタ順を変更
; 2012.09.20 : TaC-CPU V2 対応
; 2012.03.02 : setPri() を ../util/crt0.s に移す
; 2011.05.20 : 新規作成
; 
; $Id$
;

; 
; C-- 言語では記述できない内容を書く(レジスタの指定など)
; 名前が.から始まる関数・変数は、プログラム内だけで参照されるローカルなラベル
; 名前が_から始まる関数・変数は、C-- プログラムから参照できるグローバルなラベル
;
; 現在のプロセス(curProc)から、別のプロセス(readyQueue の先頭プロセス）へ
; CPU の使用権を渡す
; 
_yield
        ;--- G13(SP)以外の CPU レジスタと FLAG をカーネルスタックに退避 ---
        push    g0              ; FLAG の保存場所を準備する
        push    g0              ; G0 を保存
        ld      g0,flag         ; FLAG を上で準備した位置に保存
        st      g0,2,sp         ;
        push    g1              ; G1 を保存
        push    g2              ; G2 を保存
        push    g3              ; G3 を保存
        push    g4              ; G4 を保存
        push    g5              ; G5 を保存
        push    g6              ; G6 を保存
        push    g7              ; G7 を保存
        push    g8              ; G8 を保存
        push    g9              ; G9 を保存
        push    g10             ; G10 を保存
        push    g11             ; G11 を保存
        push    fp              ; フレームポインタ(G12)を保存
        push    usp             ; ユーザモードスタックポインタ(G14)を保存
	; 
        ;------- G13(SP)を PCB に保存 ---------------------------
        ld      g1,_curProc     ; G1 <- curProc
        st      sp,0,g1         ; [G1+0] は PCB の sp フィールド
	; 
        ;------- [curProc の magic フィールド]をチェック ---------
        ld      g0,30,g1        ; [G1+30] は PCB の magic フィールド
        cmp     g0,#0xabcd      ; P_MAGIC と比較、一致しなければ
        jnz     .stkOverFlow    ; カーネルスタックがオーバーフローしている
        
_dispatch
        ;-------- 次に実行するプロセスの G13(SP)を復元 ----------
        ld      g0,_readyQueue  ; 実行可能列の番兵のアドレス
        ld      g0,28,g0        ; [G0+28] は PCB の next フィールド(先頭の PCB)
        st      g0,_curProc     ; 現在のプロセス(curProc)に設定する
        ld      sp,0,g0         ; PCB から SP を取り出す
	;
        ;-------- G13(SP)以外の CPU レジスタを復元 -----------
        pop     usp             ; ユーザモードスタックポインタ(G14)を復元
        pop     fp              ; フレームポインタ(G12)を復元
        pop     g11             ; G11 を復元
        pop     g10             ; G10 を復元
        pop     g9              ; G9 を復元
        pop     g8              ; G8 を復元
        pop     g7              ; G7 を復元
        pop     g6              ; G6 を復元
        pop     g5              ; G5 を復元
        pop     g4              ; G4 を復元
        pop     g3              ; G3 を復元
        pop     g2              ; G2 を復元
        pop     g1              ; G1 を復元
        pop     g0              ; G0 を復元
	;
        ;------------- PSW(FLAG と PC)を復元 -----------------
        reti                    ; RETI 命令で一度に POP して復元する

; カーネルスタックがオーバーフローして PCB が破壊された場合、システムを停止する
.stkOverFlow
	push    sp
        ld      g0,#.L1         ; "kernel:stack overflow" を
        push    g0              ;  スタックに積む
        call    _panic          ; panic("kernel:stack overflow(sp=%04x)")

.L1     string  "kernel:stack overflow(sp=%04x)"
