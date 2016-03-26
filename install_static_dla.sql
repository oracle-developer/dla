
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
prompt    Dictionary Long Application Installer (for 9.2 and 10.1 databases)
prompt    ==================================================================
prompt
prompt    This will install the Dictionary Long Application (static version).
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
 
prompt Installing application context...

create context dictionary_ctx
   using dictionary_pkg;


prompt Installing types...

create type dba_constraints_ot as object
( owner                varchar2(30)
, constraint_name      varchar2(30)
, constraint_type      varchar2(1)
, table_name           varchar2(30)
, search_condition     clob
, r_owner              varchar2(30)
, r_constraint_name    varchar2(30)
, delete_rule          varchar2(9)
, status               varchar2(8)
, deferrable           varchar2(14)
, deferred             varchar2(9)
, validated            varchar2(13)
, generated            varchar2(14)
, bad                  varchar2(3)
, rely                 varchar2(4)
, last_change          date
, index_owner          varchar2(30)
, index_name           varchar2(30)
, invalid              varchar2(7)
, view_related         varchar2(14)
);
/

create type dba_constraints_ntt 
   as table of dba_constraints_ot;
/

create type dba_tab_columns_ot as object
( owner                   varchar2(30)
, table_name              varchar2(30)
, column_name             varchar2(30)
, data_type               varchar2(106)
, data_type_mod           varchar2(3)
, data_type_owner         varchar2(30)
, data_length             number(22)
, data_precision          number(22)
, data_scale              number(22)
, nullable                varchar2(1)
, column_id               number(22)
, default_length          number(22)
, data_default            clob
, num_distinct            number(22)
, low_value               raw(32)
, high_value              raw(32)
, density                 number(22)
, num_nulls               number(22)
, num_buckets             number(22)
, last_analyzed           date
, sample_size             number(22)
, character_set_name      varchar2(44)
, char_col_decl_length    number(22)
, global_stats            varchar2(3)
, user_stats              varchar2(3)
, avg_col_len             number(22)
, char_length             number(22)
, char_used               varchar2(1)
, v80_fmt_image           varchar2(3)
, data_upgraded           varchar2(3)
);
/

create type dba_tab_columns_ntt 
   as table of dba_tab_columns_ot;
/

create type dba_tab_partitions_ot as object
( table_owner          varchar2(30)
, table_name           varchar2(30)
, composite            varchar2(3)
, partition_name       varchar2(30)
, subpartition_count   number
, high_value           clob
, high_value_length    number
, partition_position   number
, tablespace_name      varchar2(30)
, pct_free             number
, pct_used             number
, ini_trans            number
, max_trans            number
, initial_extent       number
, next_extent          number
, min_extent           number
, max_extent           number
, pct_increase         number
, freelists            number
, freelist_groups      number
, logging              varchar2(7)
, compression          varchar2(8)
, num_rows             number
, blocks               number
, empty_blocks         number
, avg_space            number
, chain_cnt            number
, avg_row_len          number
, sample_size          number
, last_analyzed        date
, buffer_pool          varchar2(7)
, global_stats         varchar2(3)
, user_stats           varchar2(3)
);
/

create type dba_tab_partitions_ntt 
   as table of dba_tab_partitions_ot;
/

create type dba_tab_subpartitions_ot as object
( table_owner            varchar2(30)
, table_name             varchar2(30)
, partition_name         varchar2(30)
, subpartition_name      varchar2(30)
, high_value             clob
, high_value_length      number
, subpartition_position  number
, tablespace_name        varchar2(30)
, pct_free               number
, pct_used               number
, ini_trans              number
, max_trans              number
, initial_extent         number
, next_extent            number
, min_extent             number
, max_extent             number
, pct_increase           number
, freelists              number
, freelist_groups        number
, logging                varchar2(3)
, compression            varchar2(8)
, num_rows               number
, blocks                 number
, empty_blocks           number
, avg_space              number
, chain_cnt              number
, avg_row_len            number
, sample_size            number
, last_analyzed          date
, buffer_pool            varchar2(7)
, global_stats           varchar2(3)
, user_stats             varchar2(3)
);
/

create type dba_tab_subpartitions_ntt 
   as table of dba_tab_subpartitions_ot;
/

create type dba_triggers_ot as object
( owner               varchar2(30)
, trigger_name        varchar2(30)
, trigger_type        varchar2(16)
, triggering_event    varchar2(227)
, table_owner         varchar2(30)
, base_object_type    varchar2(16)
, table_name          varchar2(30)
, column_name         varchar2(4000)
, referencing_names   varchar2(128)
, when_clause         varchar2(4000)
, status              varchar2(8)
, description         varchar2(4000)
, action_type         varchar2(11)
, trigger_body        clob
);
/

create type dba_triggers_ntt 
   as table of dba_triggers_ot;
/

create type dba_views_ot as object
( owner            varchar2(30)
, view_name        varchar2(30)
, text_length      number
, text             clob
, type_text_length number
, type_text        varchar2(4000)
, oid_text_length  number
, oid_text         varchar2(4000)
, view_type_owner  varchar2(30)
, superview_name   varchar2(30) 
);
/

create type dba_views_ntt 
   as table of dba_views_ot;
/

create type filter_ot as object
( name   varchar2(30)
, value  varchar2(4000)
);
/

create type filter_ntt
   as table of filter_ot;
/

prompt Installing package...

create package dictionary_pkg as

   /*
   || --------------------------------------------------------------------------------------------
   ||
   || Name:        DICTIONARY_PKG
   ||
   || Description: Package of pipelined function wrappers to DBA views with LONG
   ||              columns. These functions convert the LONG columns to CLOBs,
   ||              which makes it possible to copy, search and manipulate them
   ||              in SQL.
   ||
   || Version:     This version is for Oracle 9.2 and 10.1 databases. Note that some
   ||              DBA_% view definitions in 10g have additional columns over their
   ||              9i equivalents. This version has been developed on 9i.
   ||
   || Included:    The following views are included:
   ||
   ||                * DBA_CONSTRAINTS
   ||                * DBA_TAB_COLUMNS ***
   ||                * DBA_TAB_PARTITIONS
   ||                * DBA_TAB_SUBPARTITIONS
   ||                * DBA_TRIGGERS
   ||                * DBA_VIEWS
   ||
   ||              *** Note that DBA_TAB_COLUMNS has an additional HISTOGRAMS column
   ||                  in 10g Release 1. This column is excluded from this application
   ||                  to enable it to run on both 9i and 10g.
   ||
   || Excluded:    The following views (with LONGs) are excluded, but can be easily
   ||              added using the existing method as templates:
   ||
   ||                Oracle 9.2
   ||                ----------
   ||                * DBA_CLUSTER_HASH_EXPRESSIONS
   ||                * DBA_IND_EXPRESSIONS 
   ||                * DBA_IND_PARTITIONS
   ||                * DBA_IND_SUBPARTITIONS
   ||                * DBA_MVIEWS
   ||                * DBA_MVIEW_AGGREGATES
   ||                * DBA_MVIEW_ANALYSIS
   ||                * DBA_OUTLINES
   ||                * DBA_REGISTERED_MVIEWS
   ||                * DBA_REGISTERED_SNAPSHOTS
   ||                * DBA_SNAPSHOTS
   ||                * DBA_SUBPARTITION_TEMPLATES
   ||                * DBA_SUMMARIES
   ||                * DBA_SUMMARY_AGGREGATES
   ||                * DBA_TAB_COLS
   ||
   ||                Oracle 10.1
   ||                -----------
   ||                As above, plus:
   ||                * DBA_NESTED_TABLE_COLS
   ||                * DBA_SQLTUNE_PLANS
   ||
   || Notes:       1. USER/ALL variants of the above can be easily added by using
   ||                 the existing functions as templates.
   ||
   ||              2. The functions return a record structure that matches the
   ||                 column structure of the underlying DBA_% view. View definitions
   ||                 are from Oracle 9i Release 2 (9.2). The LONG column in each
   ||                 DBA_% view is returned as a CLOB from the pipelined function.
   ||
   ||              3. Each pipelined function is further encapsulated in a view for
   ||                 ease of query. Views are named V_[dba_view name], e.g. 
   ||                 V_DBA_VIEWS.
   ||
   ||              4. A small number of filters can be set before running a query 
   ||                 against the pipelined function (or wrapper view) to limit the
   ||                 amount of data returned. See SET_FILTER and usage notes for
   ||                 details.  
   ||
   || Usage:       a) Query direct from function
   ||              -----------------------------
   ||              e.g. Query DBA_VIEWS where view text contains table SOME_TABLE.
   ||
   ||              SELECT owner, view_name, text
   ||              FROM   TABLE(dictionary_pkg.dba_views)
   ||              WHERE  UPPER(text) LIKE '%SOME_TABLE%';
   ||
   ||              b) Query direct from wrapper views
   ||              ----------------------------------
   ||              e.g. Query V_DBA_VIEWS where view text contains table SOME_TABLE.
   ||
   ||              SELECT owner, view_name, text
   ||              FROM   v_dba_views
   ||              WHERE  UPPER(text) LIKE '%SOME_TABLE%';
   ||
   ||              c) Use the filter APIs to restrict the function return
   ||              ------------------------------------------------------
   ||              e.g. Add filters to restrict V_DBA_VIEWS to SCOTT.SOME_VIEW
   ||
   ||              BEGIN
   ||                 dictionary_pkg.set_filter(p_name  => 'OWNER',
   ||                                           p_value => 'SCOTT');
   ||                 dictionary_pkg.set_filter(p_name  => 'VIEW_NAME',
   ||                                           p_value => 'SOME_VIEW');
   ||              END;
   ||              /
   ||
   ||              SELECT owner, view_name, text
   ||              FROM   v_dba_views;  --<-- returns 1 row only for SCOTT.SOME_VIEW
   ||
   ||              d) Clear the filters
   ||              --------------------
   ||              e.g. Clear all current filters.
   ||
   ||              BEGIN
   ||                 dictionary_pkg.clear_filter;
   ||              END;
   ||              /
   ||
   ||              e.g. Clear a specific filter.
   ||
   ||              BEGIN
   ||                 dictionary_pkg.clear_filter( p_name  => 'OWNER',
   ||                                              p_value => 'SCOTT' );
   ||              END;
   ||              /
   ||
   ||              e) Show the current filters
   ||              ---------------------------
   ||              e.g. Using API (can alternatively use SESSION_CONTEXT).
   ||
   ||              SELECT *
   ||              FROM   TABLE(dictionary_pkg.show_filters);
   ||
   || License:     MIT License
   ||              Copyright (c) 2007 Adrian Billington, www.oracle-developer.net
   ||              See https://github.com/oracle-developer/dla/blob/master/LICENSE
   ||
   || --------------------------------------------------------------------------------------------
   */

   /*
   || SET_FILTER sets a small range of filters to limit the amount of data returned
   || from a query. For example, to restrict the DBA_TRIGGERS function (or 
   || V_DBA_TRIGGERS wrapper view) to SCOTT, set the OWNER filter to 'SCOTT' before
   || executing the query.
   ||
   || Valid filters are:
   ||
   ||    * OWNER
   ||    * TABLE_NAME
   ||    * VIEW_NAME
   ||    * COLUMN_NAME
   ||    * CONSTRAINT_NAME
   ||    * TRIGGER_NAME
   ||    * PARTITION_NAME
   ||    * SUBPARTITION_NAME
   ||
   || Invalid filters will raise ORA-20000.
   ||
   || Additional filters can easily be added to the package body as required.
   */
   procedure set_filter(
             p_name  in varchar2,
             p_value in varchar2
             );

   /*
   || CLEAR_FILTER removes a filter so that it doesn't restrict any subsequent
   || queries. Valid filters are:
   ||
   ||    * ALL
   ||    * OWNER
   ||    * TABLE_NAME
   ||    * VIEW_NAME
   ||    * COLUMN_NAME
   ||    * CONSTRAINT_NAME
   ||    * TRIGGER_NAME
   ||    * PARTITION_NAME
   ||    * SUBPARTITION_NAME
   */
   procedure clear_filter( 
             p_name in varchar2 default 'ALL'
             );

   /*
   || Table function to show current filters. Alternatively,
   || query the SESSION_CONTEXT built-in view.
   */
   function show_filters return filter_ntt;

   /*
   || Pipelined functions declarations follow. Note that each of these is
   || encapsulated in a V_% wrapper view as part of the dictionary implementation.
   */
   function dba_constraints
      return dba_constraints_ntt pipelined;
   
   function dba_tab_columns
      return dba_tab_columns_ntt pipelined;

   function dba_tab_partitions
      return dba_tab_partitions_ntt pipelined;

   function dba_tab_subpartitions
      return dba_tab_subpartitions_ntt pipelined;

   function dba_triggers
      return dba_triggers_ntt pipelined;

   function dba_views
      return dba_views_ntt pipelined;

end dictionary_pkg;
/

create package body dictionary_pkg as

   /*
   || --------------------------------------------------------------------------------
   ||
   || Name:        DICTIONARY_PKG
   ||
   || Description: See package specification for details.
   ||
   || License:     MIT License
   ||              Copyright (c) 2007 Adrian Billington, www.oracle-developer.net
   ||              See https://github.com/oracle-developer/dla/blob/master/LICENSE
   ||
   || --------------------------------------------------------------------------------
   */

   type args_ntt is table of varchar2(30);

   -----------------------------------------------------------------------------------
   function long2clob( p_view     in varchar2,
                       p_long_col in varchar2,
                       p_cols     in args_ntt,
                       p_vals     in args_ntt ) return clob is

      c binary_integer;
      s varchar2(32767) := 'select %l% from %v% where 1=1 ';
      p varchar2(32767) := ' and %c% = :bv%n%';
      v varchar2(32767);
      r clob;
      l integer := 32767;
      o integer := 0;
      n integer;
      
   begin
      
      /*
      || Build the SQL statement used to fetch the single long...
      */
      s := replace(replace(s, '%l%', p_long_col), '%v%', p_view);
      for i in 1 .. p_cols.count loop
         s := s || replace(replace(p, '%c%', p_cols(i)), '%n%', to_char(i));
      end loop;

      /*
      || Parse the cursor and bind the inputs...
      */
      c := dbms_sql.open_cursor;
      dbms_sql.parse(c, s, dbms_sql.native);
      for i in 1 .. p_vals.count loop
         dbms_sql.bind_variable(c, ':bv'||i, p_vals(i));
      end loop;

      /*
      || Fetch the single long piecewise...
      */
      dbms_sql.define_column_long(c, 1);
      n := dbms_sql.execute_and_fetch(c);
      loop
         dbms_sql.column_value_long(c, 1, 32767, o, v, l);
         r := r || v;
         o := o + 32767;
         exit when l < 32767;
      end loop;

      /*
      || Finish...
      */
      dbms_sql.close_cursor(c);
      return r;
 
   end long2clob;

   -----------------------------------------------------------------------------------
   function filter_is_valid( p_name in varchar2 ) return boolean is
   begin
      return (upper(p_name) in ('OWNER','TABLE_NAME','VIEW_NAME',
                                'CONSTRAINT_NAME','COLUMN_NAME','TRIGGER_NAME',
                                'PARTITION_NAME','SUBPARTITION_NAME'));       
   end filter_is_valid;

   -----------------------------------------------------------------------------------
   procedure invalid_filter( p_name in varchar2 ) is
   begin
      raise_application_error( -20000, p_name || ' not a valid filter' );
   end invalid_filter;

   -----------------------------------------------------------------------------------
   procedure set_filter( p_name  in varchar2,
                         p_value in varchar2 ) is
   begin
      if filter_is_valid(p_name) then
         dbms_session.set_context( 'DICTIONARY_CTX', p_name, p_value );
      else
         invalid_filter(p_name);
      end if;
   end set_filter;

   -----------------------------------------------------------------------------------
   procedure clear_filter( p_name in varchar2 default 'ALL' ) is
   begin
      if upper(p_name) = 'ALL' then
         dbms_session.clear_context( 'dictionary_ctx', null );
      elsif filter_is_valid(p_name) then
         dbms_session.clear_context( 'dictionary_ctx', null, p_name );
      else
         invalid_filter(p_name);
      end if;
   end clear_filter;

   -----------------------------------------------------------------------------------
   function show_filters return filter_ntt is

      nt_filters filter_ntt;

   begin

      /*
      || Use SESSION_CONTEXT view rather than DBMS_SESSION.LIST_CONTEXT
      || in case other contexts are heavily used...
      */
      select filter_ot(attribute, value) bulk collect into nt_filters
      from   session_context
      where  upper(namespace) = 'DICTIONARY_CTX';

      return nt_filters;

   end show_filters;

   -----------------------------------------------------------------------------------
   function dba_constraints return dba_constraints_ntt pipelined is

      cursor c is
         select *
         from   dba_constraints
         where (   owner = sys_context('dictionary_ctx','owner')
                or sys_context('dictionary_ctx','owner') is null )
         and   (   constraint_name = sys_context('dictionary_ctx','constraint_name')
                or sys_context('dictionary_ctx','constraint_name') is null )
         and   (   table_name = sys_context('dictionary_ctx','table_name')
                or sys_context('dictionary_ctx','table_name') is null );

      r c%rowtype;

   begin
      open c;
      loop
         begin
            fetch c into r;
            exit when c%notfound;
            pipe row ( 
               dba_constraints_ot( 
                  r.owner, r.constraint_name, r.constraint_type, r.table_name,
                  r.search_condition, r.r_owner, r.r_constraint_name,
                  r.delete_rule, r.status, r.deferrable, r.deferred, r.validated,
                  r.generated, r.bad, r.rely, r.last_change, r.index_owner,
                  r.index_name, r.invalid, r.view_related 
                  ));
         exception
            when value_error then
               pipe row (
                  dba_constraints_ot(
                     r.owner, r.constraint_name, r.constraint_type, r.table_name,
                     long2clob( 
                        p_view      => 'DBA_CONSTRAINTS',
                        p_long_col  => 'SEARCH_CONDITION',
                        p_cols      => args_ntt('OWNER','CONSTRAINT_NAME'),
                        p_vals      => args_ntt(r.owner,r.constraint_name)
                        ),
                     r.r_owner, r.r_constraint_name, r.delete_rule, r.status, 
                     r.deferrable, r.deferred, r.validated, r.generated, r.bad, 
                     r.rely, r.last_change, r.index_owner, r.index_name, r.invalid,
                     r.view_related
                     ));
         end;
      end loop;
      close c;
      return;
   end dba_constraints;

   -----------------------------------------------------------------------------------
   function dba_tab_columns return dba_tab_columns_ntt pipelined is

      cursor c is
         select *
         from   dba_tab_columns
         where (   owner = sys_context('dictionary_ctx','owner')
                or sys_context('dictionary_ctx','owner') is null )
         and   (   table_name = sys_context('dictionary_ctx','table_name')
                or sys_context('dictionary_ctx','table_name') is null )
         and   (   column_name = sys_context('dictionary_ctx','column_name')
                or sys_context('dictionary_ctx','column_name') is null );

      r c%rowtype;

   begin
      open c;
      loop
         begin
            fetch c into r;
            exit when c%notfound;
            pipe row ( 
               dba_tab_columns_ot( 
                  r.owner, r.table_name, r.column_name, r.data_type,
                  r.data_type_mod, r.data_type_owner, r.data_length,
                  r.data_precision, r.data_scale, r.nullable, r.column_id,
                  r.default_length, r.data_default, r.num_distinct,
                  r.low_value, r.high_value, r.density, r.num_nulls,
                  r.num_buckets, r.last_analyzed, r.sample_size, 
                  r.character_set_name, r.char_col_decl_length, 
                  r.global_stats, r.user_stats, r.avg_col_len, r.char_length,
                  r.char_used, r.v80_fmt_image, r.data_upgraded
                  ));
         exception
            when value_error then
               pipe row (
                  dba_tab_columns_ot(
                     r.owner, r.table_name, r.column_name, r.data_type,
                     r.data_type_mod, r.data_type_owner, r.data_length,
                     r.data_precision, r.data_scale, r.nullable, r.column_id,
                     r.default_length, 
                     long2clob(
                        p_view      => 'DBA_TAB_COLUMNS',
                        p_long_col  => 'DATA_DEFAULT',
                        p_cols      => args_ntt('OWNER','TABLE_NAME','COLUMN_NAME'),
                        p_vals      => args_ntt(r.owner,r.table_name,r.column_name)
                        ),
                     r.num_distinct, r.low_value, r.high_value, r.density, 
                     r.num_nulls, r.num_buckets, r.last_analyzed, r.sample_size, 
                     r.character_set_name, r.char_col_decl_length, 
                     r.global_stats, r.user_stats, r.avg_col_len, r.char_length,
                     r.char_used, r.v80_fmt_image, r.data_upgraded
                     ));
         end;
      end loop;
      close c;
      return;
   end dba_tab_columns;

   -----------------------------------------------------------------------------------
   function dba_tab_partitions return dba_tab_partitions_ntt pipelined is

      cursor c is
         select *
         from   dba_tab_partitions
         where (   table_owner = sys_context('dictionary_ctx','owner')
                or sys_context('dictionary_ctx','owner') is null )
         and   (   table_name = sys_context('dictionary_ctx','table_name')
                or sys_context('dictionary_ctx','table_name') is null )
         and   (   partition_name = sys_context('dictionary_ctx','partition_name')
                or sys_context('dictionary_ctx','partition_name') is null );

      r c%rowtype;

   begin
      open c;
      loop
         begin
            fetch c into r;
            exit when c%notfound;
            pipe row ( 
               dba_tab_partitions_ot( 
                  r.table_owner, r.table_name, r.composite, r.partition_name,
                  r.subpartition_count, r.high_value, r.high_value_length,
                  r.partition_position, r.tablespace_name, r.pct_free, r.pct_used,
                  r.ini_trans, r.max_trans, r.initial_extent, r.next_extent,
                  r.min_extent, r.max_extent, r.pct_increase, r.freelists,
                  r.freelist_groups, r.logging, r.compression, r.num_rows, r.blocks,
                  r.empty_blocks, r.avg_space, r.chain_cnt, r.avg_row_len,
                  r.sample_size, r.last_analyzed, r.buffer_pool, r.global_stats,
                  r.user_stats
                  ));
         exception
            when value_error then
               pipe row (
                  dba_tab_partitions_ot(
                     r.table_owner, r.table_name, r.composite, r.partition_name, 
                     r.subpartition_count, 
                     long2clob(
                        p_view      => 'DBA_TAB_PARTITIONS',
                        p_long_col  => 'HIGH_VALUE',
                        p_cols      => args_ntt('TABLE_OWNER','TABLE_NAME','PARTITION_NAME'),
                        p_vals      => args_ntt(r.table_owner,r.table_name,r.partition_name)
                        ),
                     r.high_value_length, r.partition_position, r.tablespace_name,
                     r.pct_free, r.pct_used, r.ini_trans, r.max_trans, r.initial_extent,
                     r.next_extent, r.min_extent, r.max_extent, r.pct_increase,
                     r.freelists, r.freelist_groups, r.logging, r.compression, 
                     r.num_rows, r.blocks, r.empty_blocks, r.avg_space, r.chain_cnt,
                     r.avg_row_len, r.sample_size, r.last_analyzed, r.buffer_pool,
                     r.global_stats, r.user_stats
                     ));
         end;
      end loop;
      close c;
      return;
   end dba_tab_partitions;

   -----------------------------------------------------------------------------------
   function dba_tab_subpartitions return dba_tab_subpartitions_ntt pipelined is

      cursor c is
         select *
         from   dba_tab_subpartitions
         where (   table_owner = sys_context('dictionary_ctx','owner')
                or sys_context('dictionary_ctx','owner') is null )
         and   (   table_name = sys_context('dictionary_ctx','table_name')
                or sys_context('dictionary_ctx','table_name') is null )
         and   (   partition_name = sys_context('dictionary_ctx','partition_name')
                or sys_context('dictionary_ctx','partition_name') is null )
         and   (   subpartition_name = sys_context('dictionary_ctx','subpartition_name')
                or sys_context('dictionary_ctx','subpartition_name') is null );

      r c%rowtype;

   begin
      open c;
      loop
         begin
            fetch c into r;
            exit when c%notfound;
            pipe row ( 
               dba_tab_subpartitions_ot( 
                  r.table_owner, r.table_name, r.partition_name, r.subpartition_name,
                  r.high_value, r.high_value_length, r.subpartition_position, 
                  r.tablespace_name, r.pct_free, r.pct_used, r.ini_trans, r.max_trans,
                  r.initial_extent, r.next_extent, r.min_extent, r.max_extent,
                  r.pct_increase, r.freelists, r.freelist_groups, r.logging,
                  r.compression, r.num_rows, r.blocks, r.empty_blocks, r.avg_space,
                  r.chain_cnt, r.avg_row_len, r.sample_size, r.last_analyzed,
                  r.buffer_pool, r.global_stats, r.user_stats
                  ));

         exception
            when value_error then
               pipe row (
                  dba_tab_subpartitions_ot(
                     r.table_owner, r.table_name, r.partition_name, r.subpartition_name,
                     long2clob(
                        p_view      => 'DBA_TAB_SUBPARTITIONS',
                        p_long_col  => 'HIGH_VALUE',
                        p_cols      => args_ntt('TABLE_OWNER','TABLE_NAME',
                                                'PARTITION_NAME','SUBPARTITION_NAME'),
                        p_vals      => args_ntt(r.table_owner,r.table_name,
                                                r.partition_name,r.subpartition_name)
                        ),
                     r.high_value_length, r.subpartition_position, r.tablespace_name,
                     r.pct_free, r.pct_used, r.ini_trans, r.max_trans,
                     r.initial_extent, r.next_extent, r.min_extent, r.max_extent,
                     r.pct_increase, r.freelists, r.freelist_groups, r.logging,
                     r.compression, r.num_rows, r.blocks, r.empty_blocks, r.avg_space,
                     r.chain_cnt, r.avg_row_len, r.sample_size, r.last_analyzed,
                     r.buffer_pool, r.global_stats, r.user_stats
                     ));
         end;
      end loop;
      close c;
      return;
   end dba_tab_subpartitions;

   -----------------------------------------------------------------------------------
   function dba_triggers return dba_triggers_ntt pipelined is

      cursor c is
         select *
         from   dba_triggers
         where (   owner = sys_context('dictionary_ctx','owner')
                or sys_context('dictionary_ctx','owner') is null )
         and   (   table_name = sys_context('dictionary_ctx','table_name')
                or sys_context('dictionary_ctx','table_name') is null )
         and   (   trigger_name = sys_context('dictionary_ctx','trigger_name')
                or sys_context('dictionary_ctx','trigger_name') is null );

      r c%rowtype;

   begin
      open c;
      loop
         begin
            fetch c into r;
            exit when c%notfound;
            pipe row (
               dba_triggers_ot(
                  r.owner, r.trigger_name, r.trigger_type,
                  r.triggering_event, r.table_owner, r.base_object_type,
                  r.table_name, r.column_name, r.referencing_names,
                  r.when_clause, r.status, r.description, r.action_type,
                  r.trigger_body
                  ));
         exception
            when value_error then
               pipe row (
                  dba_triggers_ot(
                     r.owner, r.trigger_name, r.trigger_type,
                     r.triggering_event, r.table_owner, r.base_object_type,
                     r.table_name, r.column_name, r.referencing_names,
                     r.when_clause, r.status, r.description, r.action_type,
                     long2clob( 
                        p_view      => 'DBA_TRIGGERS',
                        p_long_col  => 'TRIGGER_BODY',
                        p_cols      => args_ntt('OWNER','TRIGGER_NAME'),
                        p_vals      => args_ntt(r.owner,r.trigger_name)
                        )
                     ));
         end;
      end loop;
      close c;
      return;
   end dba_triggers;

   -----------------------------------------------------------------------------------
   function dba_views return dba_views_ntt pipelined is

      cursor c is
         select *
         from   dba_views
         where (   owner = sys_context('dictionary_ctx','owner')
                or sys_context('dictionary_ctx','owner') is null )
         and   (   view_name = sys_context('dictionary_ctx','view_name')
                or sys_context('dictionary_ctx','view_name') is null );

      r c%rowtype;

   begin
      open c;
      loop
         begin
            fetch c into r;
            exit when c%notfound;
            pipe row (
               dba_views_ot(
                  r.owner, r.view_name, r.text_length, r.text, 
                  r.type_text_length, r.type_text, r.oid_text_length, 
                  r.oid_text, r.view_type_owner, r.superview_name
                  ));
         exception
            when value_error then
               pipe row (
                  dba_views_ot(
                     r.owner, r.view_name, r.text_length,
                     long2clob(
                        p_view      => 'DBA_VIEWS',
                        p_long_col  => 'TEXT',
                        p_cols      => args_ntt('OWNER','VIEW_NAME'),
                        p_vals      => args_ntt(r.owner,r.view_name)
                        ),
                     r.type_text_length, r.type_text, r.oid_text_length,
                     r.oid_text, r.view_type_owner, r.superview_name
                     ));
         end;
      end loop;
      close c;
      return;
   end dba_views;

   -----------------------------------------------------------------------------------

end dictionary_pkg;
/


prompt Installing views...

create view v_dba_constraints as 
   select * from table(dictionary_pkg.dba_constraints);

create view v_dba_tab_columns as 
   select * from table(dictionary_pkg.dba_tab_columns);

create view v_dba_tab_partitions as 
   select * from table(dictionary_pkg.dba_tab_partitions);

create view v_dba_tab_subpartitions as 
   select * from table(dictionary_pkg.dba_tab_subpartitions);

create view v_dba_triggers as 
   select * from table(dictionary_pkg.dba_triggers);

create view v_dba_views as 
   select * from table(dictionary_pkg.dba_views);


prompt Installing synonyms and privileges...
create or replace public synonym dictionary_pkg for dictionary_pkg;
grant execute on dictionary_pkg to public;

create or replace public synonym v_dba_constraints for v_dba_constraints;
grant select on v_dba_constraints to public;

create or replace public synonym v_dba_tab_columns for v_dba_tab_columns;
grant select on v_dba_tab_columns to public;

create or replace public synonym v_dba_tab_partitions for v_dba_tab_partitions;
grant select on v_dba_tab_partitions to public;

create or replace public synonym v_dba_tab_subpartitions for v_dba_tab_subpartitions;
grant select on v_dba_tab_subpartitions to public;

create or replace public synonym v_dba_triggers for v_dba_triggers;
grant select on v_dba_triggers to public;

create or replace public synonym v_dba_views for v_dba_views;
grant select on v_dba_views to public;


prompt
prompt
prompt **************************************************************************
prompt    Installation complete.
prompt **************************************************************************
