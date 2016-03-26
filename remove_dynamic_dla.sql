
-- Dictionary Long Application
-- ---------------------------
-- MIT License

-- Copyright (c) 2007 Adrian Billington, www.oracle-developer.net

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

set pause on

prompt
prompt
prompt **************************************************************************
prompt **************************************************************************
prompt
prompt    Dictionary Long Application Uninstaller (for 10.2+ databases)
prompt    =============================================================
prompt
prompt    This will uninstall the Dictionary Long Application (dynamic version).
prompt
prompt    To continue press Enter. To quit press Ctrl-C.
prompt
prompt    (c) oracle-developer.net
prompt
prompt **************************************************************************
prompt **************************************************************************
prompt
prompt

pause

prompt Removing application...

drop public synonym v_dba_constraints;
drop public synonym v_dba_tab_columns;
drop public synonym v_dba_tab_partitions;
drop public synonym v_dba_tab_subpartitions;
drop public synonym v_dba_triggers;
drop public synonym v_dba_views;

drop view v_dba_constraints;
drop view v_dba_tab_columns;
drop view v_dba_tab_partitions;
drop view v_dba_tab_subpartitions;
drop view v_dba_triggers;
drop view v_dba_views;

drop context dla_ctx; 
drop package dla_pkg; 
drop type dla_filter_ntt;
drop type dla_filter_ot;
drop type dla_ot;

prompt
prompt
prompt **************************************************************************
prompt    Uninstall complete.
prompt **************************************************************************
