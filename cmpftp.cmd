/* directory comparison for ftp server */
'@echo off'
IF arg(1) == "binhoster" THEN drive="w:\"; ELSE
IF arg(1) == "revido" THEN drive="v:\"; ELSE DO
  say 'unknown comparison target: ' arg(1)
  exit 1;
END;

say 'listing remote dir ...'
'allfiles -yc' drive '| sort >e:\home\aux\'arg(1)'.files'
say 'listing local dir ...'
'allfiles -yc E:\home\public_html | sort >e:\home\aux\pubhtml.files'
say 'launching kdiff3.'
'detach kdiff3 e:\home\aux\pubhtml.files e:\home\aux\'arg(1)'.files'


