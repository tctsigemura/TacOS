;
; TacOS Source Code
;    Tokuyama kousen Advanced educational Computer
;
; Copyright (C) 2009-2022 by
;                      Dept. of Computer Science and Electronic Engineering,
;                      Tokuyama College of Technology, JAPAN
;
;   上記著作権者は，Free Software Foundation によって公開されている GNU 一般公
; 衆利用許諾契約書バージョン２に記述されている条件を満たす場合に限り，本ソース
; コード(本ソースコードを改変したものを含む．以下同様)を使用・複製・改変・再配
; 布することを無償で許諾する．
;
;   本ソースコードは＊全くの無保証＊で提供されるものである。上記著作権者および
; 関連機関・個人は本ソースコードに関して，その適用可能性も含めて，いかなる保証
; も行わない．また，本ソースコードの利用により直接的または間接的に生じたいかな
; る損害に関しても，その責任を負わない．
;

;
; util/crt0.s : カーネル用スタートアップ
;
; 2022.08.27 : _mul32のバグを訂正
; 2022.07.08 : _readMap,_writeMap追加
; 2022.07.01 : Tec7d専用(SPの位置は常に0xffe0)
; 2021.10.15 : TaC-CPU V3 対応(mull 命令が使用できないので)
; 2021.10.15 : _div32削除
; 2019.12.27 : 論理アドレスから物理アドレスの変換 _ItoP(), _AtoP() 追加
; 2018.11.30 : TaC7a と TaC7b を自動識別し SP の初期値を決める．
; 2017.12.10 : _setPri のコメントを訂正
; 2016.01.20 : __fp() を追加
; 2016.01.06 : コメントの体裁を清書
; 2015.09.02 : __AtoA 追加(重村)
; 2014.05.07 : 村田開発開始
; 2012.09.20 : TaC-CPU V2 対応、Kernel 専用(_end(), _memsize() を削除)
; 2012.03.02 : halt() を追加
; 2012.03.02 : TeC7 用に書き換える
; 2011.05.26 : TaC-OS 用に不要なものを削除する
; 2010.07.20 : Subversion の管理に入る
; 2009.11.05 : Boot 用と Kernel 用をマージしなおす
; 2009.05.13 : v0.1.1 : v0.1.0 から ei(), di() をバックポート
;
; $Id$
;

; [sp+2]が第1引数、[sp+4]が第2引数

__memSiz ws     1           ; 主記憶の最終アドレスを格納する

.start                      ; IPL からここにジャンプしてくる
        ld      sp,#0xffe0  ; 一致すれば TaC7a-d の新しいファームなので 0xffe0
        st      sp,__memSiz ; カーネルに主記憶のサイズを知らせる
        call    _main       ; カーネルのメインに飛ぶ
.m      halt                ; 万一カーネルが終了したらここで終わる
        jmp     .m          ;

;; CPU のフラグの値を返すと同時に新しい値に変更
_setPri
        ld      g0,2,sp     ; 引数の値を G0 に取り出す
        push    g0          ; 新しい状態をスタックに積む
        ld      g0,flag     ; 古いフラグの値を返す準備をする
        reti                ; reti は FLAG と PC を同時に pop する

;; ワード(16bit)を I/O ポートから入力する
_in                         ; int in(int p);
        ld      g1,2,sp     ; ポートアドレス
        in      g0,g1       ; I/O ポートから入力する
        ret

;; ワードを I/O ポートへ出力する
_out                        ; void out(int p,int v);
        ld      g0,2,sp     ; ポートアドレス
        ld      g1,4,sp     ; 出力データ
        out     g1,g0       ; I/O ポートへ出力する
        ret

;; CPU を停止
_halt
        halt
        jmp     _halt

;; 一時停止
_pause
        halt
        ret

;; FP の値を取得する
__fp
        ld      g0,0,fp
        ret

;; アドレスから整数へ変換
__AtoI                      ; int _AtoI(void[] a);
;; アドレスからアドレスへ変換
__AtoA                      ; void[] _AtoA(void[] a);
;; 整数からアドレスへ変換
__ItoA
        ld      g0,2,sp     ; void[] _ItoA(int a);
        ret

;; 論理アドレスから物理アドレス（整数）へ変換
__ItoP                      ; void[] _AtoP(int a, PCB p);
;; 論理アドレスから物理アドレスへ変換
__AtoP                      ; void[] _AtoP(void[] a, PCB p);
        ld      g0,4,sp     ;   g0 = p
        ld      g0,16,g0    ;   g0 = p.memBase
        add     g0,2,sp     ;   g0 += a
        ret

;; アドレスと整数の加算
__addrAdd                   ; void[] _addrAdd(void[] a, int i);
        ld      g0,2,sp
        add     g0,4,sp
        ret

;; 符号なし整数の比較
__uCmp                      ; int _uCmp(int a, int b);
;; アドレス比較(第1引数の方が大きいとき1,等しいとき0、小さいとき-1)
__aCmp                      ; int _aCmp(void[] a, void b);
        ld      g0,2,sp
        cmp     g0,4,sp
        ld      g0,#1
        jhi     .L1
        ld      g0,#0
        jz      .L1
        ld      g0,#-1
.L1     ret

;; 呼び出した C-- 関数の第2引数のアドレスを返す
__args                      ; void[] _args();
        ld      g0,fp
        add     g0,#6
        ret

;; 32ビット加算ルーチン
__add32                     ; int[] _add32(int[] dst, int[] src);
        ld      g0,2,sp     ; ディスティネーション(アドレス)
        ld      g1,4,sp     ; ソース(アドレス)
        ld      g2,2,g0     ; ディスティネーション下位ワード
        add     g2,2,g1     ; ソース下位ワード
        st      g2,2,g0     ; ディスティネーション下位ワード
        ld      g2,0,g0     ; ディスティネーション上位ワード
        jnc     .L2
        add     g2,#1       ; キャリーがあった場合は +1 する
.L2
        add     g2,0,g1     ; ソース上位ワード
        st      g2,0,g0     ; ディスティネーション上位ワード
        ret

;; 32ビット減算ルーチン
__sub32                     ; int[] _sub32(int[] dst, int[] src);
        ld      g0,2,sp     ; ディスティネーション(アドレス)
        ld      g1,4,sp     ; ソース(アドレス)
        ld      g2,2,g0     ; ディスティネーション下位ワード
        sub     g2,2,g1     ; ソース下位ワード
        st      g2,2,g0     ; ディスティネーション下位ワード
        ld      g2,0,g0     ; ディスティネーション上位ワード
        jnc     .L3
        sub     g2,#1       ; ボローがあった場合は -1 する
.L3
        sub     g2,0,g1     ; ソース上位ワード
        st      g2,0,g0     ; ディスティネーション上位ワード
        ret

;; 32ビットかけ算ルーチン
__mul32                     ; int[] _mul32(int[] dst, int src)
        push    g3
        ld      g0,4,sp     ; ディスティネーション(アドレス)
        ld      g1,2,g0     ; ディスティネーション下位ワード(B)
        ld      g2,#0       ; (g1,g2) <= (B,0)
        ld      g3,#16      ; カウンタ
.L4     ld      g0,#0       ; g0をとりあえず0にする
        shll    g1,#1       ; g1 <<= 1
        jnc     .L5         ; g1の最上位が1だったなら
        ld      g0,6,sp     ;  g0にソースをロード
.L5     shll    g2,#1       ; g2 <<= 1
        jnc     .L6         ; キャリーがあったら
        add     g1,#1       ;  g1 += 1
.L6     add     g2,g0       ; g2 += g0
        jnc     .L7         ; キャリーがあったら
        add     g1,#1       ;  g1 += 1
.L7     sub     g3,#1       ; 16回繰り返したか
        jnz     .L4
        ld      g0,4,sp     ; ディスティネーション(アドレス)
        st      g1,0,g0     ; ディスティネーション上位ワード
        st      g2,2,g0     ; ディスティネーション下位ワード
        pop     g3
        ret

;;ビットマップの指定ビット読み込み
__readMap
        ld      g1,2,sp     ; ビットマップのアドレス
        ld      g2,4,sp     ; 何番目のビットを読み込むか
        push    g2          ; g2の値を待避
        shrl     g2,#3      ; g2を3ビット右シフト
        add     g1,g2       ; g1の値にg2の値を加算      
        pop     g2          ; g2の値を待避させた時の状態に
        and     g2,#7       ; g2を下位3ビットでマスク
        ld      g0,@g1      ; g0にg1のアドレスにある値を格納
        shrl     g0,g2      ; g0をg2の値ビット右シフト
        and     g0,#1       ; g0の最下位ビットを取り出す
        ret

;;ビットマップの指定ビットに値を書き込み
__writeMap
        ld      g1,2,sp     ; ビットマップのアドレス
        ld      g2,4,sp     ; 何番目のビットに書き込むか
        ld      g0,6,sp     ; 0,1のどっちを書き込むか
        push    g3
        push    g2          ; g2の値を待避
        shrl     g2,#3      ; g2の値を3ビット右シフト
        add     g1,g2       ; g1にg2の値を加算
        pop     g2
        and     g2,#7       ; g2を下位３ビットでマスク
        ld      g3,#1       ; g3に1を読み込み
        shll    g3,g2       ; g3をg2ビット分左シフト
        ld      g2,@g1      ; g2にg1のアドレスにある値を格納
        cmp     g0,#0       ; g0の値と0を比較
        jz      .L8         ; g0が0だったらジャンプ
        or      g2,g3       ; g0が1の時g2とg3のor
        jmp     .L9         ; .L8からはg0が0の命令のためジャンプ
.L8     xor     g3,#-1      ; g3と-1(0xFFFF)をxor
        and     g2,g3       ; g2とg3のand
.L9     st      g2,@g1      ; g2の値をg1のアドレスに格納
        pop     g3
        ret
