

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
