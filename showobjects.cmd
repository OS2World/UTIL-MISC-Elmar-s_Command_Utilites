/*                                                                    */
/* Sample program to display a list of all known objects              */
/*                                                                    */
/* Usage: ShowObj {>logfile}                                          */
/*                                                                    */
/* Note:  This program needs Henk Kelders excellent DLL WPTOOLS.DLL!  */
/*                                                                    */
/*        Tested under OS/2 WARP Connect. May not work on other OS/2  */
/*        versions!                                                   */
/*                                                                    */
/* History                                                            */
/*   14.01.1996 v1.00 /bs                                             */
/*     - initial release (for RXT&T v2.00)                            */
/*                                                                    */
/* (c) 1996 Bernd Schemmer, Germany, EMail: Bernd.Schemmer@gmx.de     */
/*                                                                    */
/* http://www.edm2.com/index.php/REXX_Tips_%26_Tricks:Change_the_WPS_with_REXX */


   /* turn on the NOVALUE condition                  */
      signal on NOVALUE

   /*  load WPTOOLS functions                        */
      call RxFuncAdd "WPToolsLoadFuncs", "WPTOOLS", "WPToolsLoadFuncs"
      call WPToolsLoadFuncs

   /*  load REXXUTIL functions                       */
      call rxFuncAdd "SysLoadFuncs", "REXXUTIL", "SysLoadFuncs"
      call SysLoadFuncs

    /* get all object handles                         */
      thisRC = SysIni( "USER", "PM_Abstract:Objects", "ALL:", "handleList" )


      call lineOut , "Object list"
      call LineOut , "==========="
      call LineOut , ""

      /* display the object data                        */
      do i = 1 to handleList.0
        curHandle = handleList.i

        call CharOut , "  " || curHandle || ": "

        cur2Indent = length( curHandle ) + 4 +2
        curIndent = 0

        /* show the data of the object                    */
        call ShowObjectData "#2" || right( "0000" || curHandle, 4 ) ,, cur2Indent, curIndent


        call LineOut , ""

      end /* do i = 1 to handleList.0 */

    exit

    /* ------------- insert the routines from the section ------------- */
    /*                 General routines for the samples                 */
    /* ---------------------------- here! ----------------------------- */
