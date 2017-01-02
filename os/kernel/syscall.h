/*
 * TacOS Source Code
 *    Tokuyama kousen Advanced educational Computer.
 *
 * Copyright (C) 2011 - 2016 by
 *                      Dept. of Computer Science and Electronic Engineering,
 *                      Tokuyama College of Technology, JAPAN
 *
 *   上記著作権者は，Free Software Foundation によって公開されている GNU 一般公
 * 衆利用許諾契約書バージョン２に記述されている条件を満たす場合に限り，本ソース
 * コード(本ソースコードを改変したものを含む．以下同様)を使用・複製・改変・再配
 * 布することを無償で許諾する．
 *
 *   本ソースコードは＊全くの無保証＊で提供されるものである。上記著作権者および
 * 関連機関・個人は本ソースコードに関して，その適用可能性も含めて，いかなる保証
 * も行わない．また，本ソースコードの利用により直接的または間接的に生じたいかな
 * る損害に関しても，その責任を負わない．
 *
 *
 */

/*
 *　kernel/syscall.h : システムコールに関するデータを含むファイル
 *
 * 2016.01.12 : E2BIG を削除
 * 2016.01.11 : システムコール番号の順番を変更(malloc と free を最後に)
 * 2016.01.02 : SLEEP を追加
 * 2015.12.17 : OPENDIR と READDIR を削除、ENOEMPENT と ENOTSFN を削除
 * 2015.12.01 : ENOTEMP を追加
 * 2015.11.30 : EFATTR を追加
 * 2015.11.26 : EBUFSIZ と EMATCH を削除
 * 2015.11.17 : MKDIR と RMDIR を追加
 * 2015.09.07 : EFAULT を追加(重村)
 * 2015.09.06 : ENOMEM を追加(重村)
 * 2015.08.20 : エラーコードのネーミングを変更
 * 2015.06.30 : TOO_LARGE_ARGC を追加
 * 2015.06.09 : CONWRITE を追加
 * 2015.06.05 : CONREAD を追加
 * 2015.06.04 : OPENDIR と READDIR を追加
 * 2015.05.22 : NOT_ZOMBIE (ゾンビ状態の子プロセスが存在しない）を追加
 * 2015.05.08 : ファイル名を変更(SysErrVla.h -> syscall.h),
                システムコール番号を追加
 * 2015.04.28 : wait システムコールで使用するエラーナンバーを追加
 * 2015.02.12 : exec システムコールで使用するエラーナンバーを追加
 * 2014.11.06 : READ と WRITE を区別するため BAD_MODE を追加
 * 2014.11.03 : mkDir システムコールで使用するエラーナンバーを追加
 * 2014.10.14 : write システムコールで使用するエラーナンバーを追加
 * 2014.10.09 : 開発開始
 *
 * $Id$
 *
 */

// kernel.cmm fatSys.cmm blkFile.cmm pm.cmm mem.cmm tty.cmm でインクルード

#ifndef _syscall_h
#define _syscall_h

// システムコール番号
#define EXEC            0
#define EXIT            1
#define WAIT            2
#define SLEEP           3
#define CREAT           4
#define REMOVE          5
#define MKDIR           6
#define RMDIR           7
#define OPEN            8
#define CLOSE           9
#define READ            10
#define WRITE           11
#define SEEK            12
#define CONREAD         13
#define CONWRITE        14
#define COMTEC          15
#define PUTSIO          16
#define GETSIO          17
#define GETPS2          18
#define MALLOC          19
#define FREE            20

// システムコールのエラー番号
#define ENAME           (-1)      // ファイル名が不正
#define ENOENT          (-2)      // 対象ファイルが見つからなかった
#define EEXIST          (-3)      // 同じディレクトリに同名のファイルが存在する
#define EOPENED         (-4)      // 対象ファイルがオープンされている
#define ENFILE          (-5)      // ファイルを開きすぎている
#define EBADF           (-6)      // 不正なファイル記述子
#define ENOSPC          (-7)      // 空き領域が不足
#define EPATH           (-8)      // パスが不正（ディレクトリでない、存在しない)
#define EMODE           (-9)      // アクセスモードが一致しない
#define EFATTR          (-10)     // ファイルの属性が不正
#define ENOTEMP         (-11)     // ディレクトリの中身が空でない
#define EINVAL          (-12)     // 引数が不正
#define EMPROC          (-13)     // プロセスが多すぎる
#define ENOEXEC         (-14)     // EXE ファイルが不正(見つからない、開けない）
#define EMAGIC          (-15)     // 不正なマジック番号
#define EMFILE          (-16)     // 1プロセスがファイルを開きすぎている
#define ECHILD          (-17)     // 子プロセスが存在しない
#define ENOZOMBIE       (-18)     // ゾンビ状態の子プロセスが存在しない
#define ENOMEM          (-19)     // メモリ不足

// ユーザプロセスのエラー
#define ESYSNUM         (-20)     // システムコール番号が不正
#define EZERODIV        (-21)     // ゼロ割算
#define EPRIVVIO        (-22)     // 特権例外
#define EILLINST        (-23)     // 不正命令
#define ESTKOVRFLW      (-24)     // スタックオーバーフロー

#endif
