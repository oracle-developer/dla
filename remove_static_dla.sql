
clear

prompt
prompt
prompt **************************************************************************
prompt **************************************************************************
prompt
prompt    Dictionary Long Application Uninstaller (for 9.2 and 10.1 databases)
prompt    ====================================================================
prompt
prompt    This will uninstall the Dictionary Long Application (static version).
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
drop public synonym dictionary_pkg;

drop type dba_views_ntt;
drop type dba_triggers_ntt;
drop type dba_tab_subpartitions_ntt;
drop type dba_tab_partitions_ntt;
drop type dba_tab_columns_ntt;
drop type dba_constraints_ntt;
drop type filter_ntt;

drop type dba_constraints_ot;
drop type dba_tab_columns_ot;
drop type dba_tab_partitions_ot;
drop type dba_tab_subpartitions_ot;
drop type dba_triggers_ot;
drop type dba_views_ot;
drop type filter_ot;

drop view v_dba_constraints;
drop view v_dba_tab_columns;
drop view v_dba_tab_partitions;
drop view v_dba_tab_subpartitions;
drop view v_dba_triggers;
drop view v_dba_views;

drop context dictionary_ctx; 
drop package dictionary_pkg; 

prompt
prompt
prompt **************************************************************************
prompt    Uninstall complete.
prompt **************************************************************************

