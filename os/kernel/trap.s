;
;  TacOS Source Code
;     Tokuyama kousen Advanced educational Computer.
;
;  Copyright (C) 2011 - 2019 by
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
; kernel/trap.s : SVC ハンドラ(トラップ)
;
; 2019.06.13 : ttyCtl を追加
; 2016.01.11 : システムコール番号のエラーチェックを変更
; 2016.01.06 : .sysNumErr を修正
; 2016.01.02 : SLEEP を追加
; 2015.12.17 : openDir と readDir を削除
; 2015.09.09 : malloc, free システムコール番号のチェックを追加(重村)
; 2015.08.28 : sysTbl の定義を追加、システムコール番号のチェックを追加
; 2015.05.20 : システムコール本体の呼び出しを修正、
;              誤ってシステムコール番号を push していたのを修正
; 2015.05.12 : パラメータの積み直しを追加、本体の呼び出し部を修正
; 2015.05.08 : 新規作成
;
; $Id$
;

; C-- 言語では記述できない内容を書く(レジスタの指定など)
; 名前が.から始まる関数・変数は、プログラム内だけで参照されるローカルなラベル
; 名前が_から始まる関数・変数は、C-- プログラムから参照できるグローバルなラベル


; ----------------------------- システムコール一覧表 --------------------------
; システムコール一覧表にシステムコールのスタブのアドレスを登録
; システムコール番号をインデクスとして使用する
; システムコール番号
;0      exec
;1      exit
;2      wait
;3      sleep
;4      creat
;5      remove
;6      mkDir
;7      rmDir
;8      open
;9      close
;10     read
;11     write
;12     seek
;13     stat
;14     ttyRead
;15     ttyWrite
;16     ttyCtl
;17     malloc
;18     free

.nSys   equ     17          ; システムコール数を定義

; .sysTbl ラベルは dw と同じ行に書くこと(同じセグメントのラベルにするため)
.sysTbl dw      _exec       ; 0  exec
        dw      _exit       ; 1  exit
        dw      _wait       ; 2  wait
        dw      _sleep      ; 3  sleep
        dw      _creat      ; 4  creat
        dw      _remove     ; 5  remove
        dw      _mkDir      ; 6  mkDir
        dw      _rmDir      ; 7  rmDIr
        dw      _open       ; 8  open
        dw      _close      ; 9  close
        dw      _read       ; 10 read
        dw      _write      ; 11 write
        dw      _seek       ; 12 seek
        dw      _stat       ; 13 stat
        dw      _ttyRead    ; 14 ttyRead
        dw      _ttyWrite   ; 15 ttyWrite
        dw      _ttyCtl     ; 16 ttyCtl
; MM の malloc(#17)と free(#18)は OS 内部専用システムコールなので SVC で扱わない

; ---------------------------- SVC ハンドラ(トラップ) -------------------------
; システムコール番号でインデックスされたシステムコールテーブル(sysTbl)から、
; 目的のシステムコールの本体を呼び出す
_svCall
; ----------- システムコール番号が妥当(0~15)かチェックする --------------------
        cmp     g0,#.nSys   ; システムコール番号とシステムコール数を比較
        jnc     .sysNumErr  ; C フラグが立たなければエラー

; ----------- システムコールのパラメータをカーネルスタックに積み直す ----------
;　システムコールに必要な情報は、G0~G3 レジスタを用いてレジスタ渡しされる
;  SVC ハンドラが呼ばれた時点で、必要な情報は G0~G3 レジスタに格納されているはず
        push    g3          ; G3(第3パラメータ)をカーネルモード用スタックに積む
        push    g2          ; G2(第2パラメータ)をカーネルモード用スタックに積む
        push    g1          ; G1(第1パラメータ)をカーネルモード用スタックに積む

; カーネルスタックの状態(今の時点でこうなっているはず)
; addr SP からの相対 スタックの中身
; 00
;       SP+0         G1    今, SP はここを指している
;       SP+2         G2
;       SP+4         G3
;       SP+6         flag
;       SP+8         PC
; FF

; ---------------------- システムコールの本体を呼び出す -----------------------
        shll    g0,#1       ; システムコール番号を2倍してテーブルを引く
        ld      g1,.sysTbl,g0 ; G1 に対象システムコールの本体のアドレスをロード
        call    0,g1        ; 対象システムコールの本体にジャンプ
        add     sp,#6       ; SP を元に戻す
        reti                ; PSW(FLAGとPC) を復元

; ----------- システムコール番号が不正だった場合、プロセスを停止する ----------
.sysNumErr
        ld      g0,#-20     ; exit の引数として ESYSNUM(-20) を
        push    g0          ;   スタックに積む
        call    _exit       ; exit を呼び出す
