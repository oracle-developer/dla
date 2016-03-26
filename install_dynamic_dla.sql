
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
prompt    Dictionary Long Application Installer (for 10.2+ databases)
prompt    ===========================================================
prompt
prompt    This will install the Dictionary Long Application (dynamic version).
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

CREATE CONTEXT dla_ctx USING dla_pkg;


prompt Installing types...

CREATE TYPE dla_filter_ot AS OBJECT
( name  VARCHAR2(30)
, value VARCHAR2(4000)
);
/

CREATE TYPE dla_filter_ntt
   AS TABLE OF dla_filter_ot;
/


prompt Installing dla_ot type specification...

CREATE TYPE dla_ot AS OBJECT
( 
  /*
  || ---------------------------------------------------------------------------------
  ||
  || Name:        dla_ot
  ||
  || Description: Implementation type for dynamic Dictionary Long Application
  ||
  || License:     MIT License
  ||              Copyright (c) 2007 Adrian Billington, www.oracle-developer.net
  ||              See https://github.com/oracle-developer/dla/blob/master/LICENSE
  ||
  || ---------------------------------------------------------------------------------
  */
  atype ANYTYPE --<-- transient record type

, STATIC FUNCTION ODCITableDescribe( 
                  rtype OUT ANYTYPE,
                  stmt  IN  VARCHAR2
                  ) RETURN NUMBER

, STATIC FUNCTION ODCITablePrepare(
                  sctx    OUT dla_ot,
                  tf_info IN  sys.ODCITabFuncInfo,
                  stmt    IN  VARCHAR2
                  ) RETURN NUMBER

, STATIC FUNCTION ODCITableStart(
                  sctx IN OUT dla_ot,
                  stmt IN     VARCHAR2
                  ) RETURN NUMBER

, MEMBER FUNCTION ODCITableFetch(
                  SELF  IN OUT dla_ot,
                  nrows IN     NUMBER,
                  rws   OUT    anydataset
                  ) RETURN NUMBER

, MEMBER FUNCTION ODCITableClose(
                  SELF IN dla_ot
                  ) RETURN NUMBER
);
/

prompt Installing dla_pkg package specification...

CREATE PACKAGE dla_pkg AS

   /*
   || ---------------------------------------------------------------------------------
   ||
   || Name:        dla_pkg
   ||
   || Description: Package wrapper to DBA views with LONG columns. This package
   ||              contains a single interface to a pipelined function implemented by
   ||              an object type (DLA_OT) using ANYDATASET.
   ||
   || Version:     This version is for Oracle 10.2.0.x and upwards.
   ||
   ||              Semantically and syntactically, this application should run on
   ||              10.1.x databases, but there is an ORA-0600 error which appears
   ||              to be a bug in the way ANYDATASET fetches CLOBs. For this reason,
   ||              it is recommended that the static version of the Dictionary Long
   ||              Application is used for versions less than 10.2.0.1.
   ||
   || Included:    Using this dynamic interface approach, it is possible to return any
   ||              dictionary view that contains a LONG. With this version of the
   ||              dictionary package, no additional setup is required to include new
   ||              views (unlike the 9i/10gR1 version). This also means that the 
   ||              USER/ALL equivalents can be queried without any additional work.
   ||
   || Notes:       1. The pipelined function returns a record structure that matches
   ||                 the column structure of the underlying DBA_% view (or query
   ||                 from that view). The only exception to this is of course the
   ||                 LONG column, which is returned from each DBA_% view as a CLOB.
   ||
   ||              2. The interface function is further encapsulated by a set of
   ||                 views for the commonly-used DBA_% views. Views are named 
   ||                 V_[dba_view name], e.g. V_DBA_VIEWS. To query other DBA_% views
   ||                 either the interface function can be used directly or V_%
   ||                 views can be setup easily using the existing examples as 
   ||                 templates.
   ||
   ||              3. A small number of filters can be set before running a query 
   ||                 against the pipelined function (or wrapper view) to limit the
   ||                 amount of data returned. See SET_FILTER and usage notes for
   ||                 details. For more specific filters, either the SET APIs can be
   ||                 extended or the underlying query against the DBA_% view can
   ||                 be modified to include additional predicates.
   ||
   ||              4. The ANYDATASET interface has been available as a Data Cartridge
   ||                 since Oracle 9i. However, the ODCI methods needed to enable dynamic
   ||                 describe of a SQL statement were not available until 10g (that is,
   ||                 we could only interface to a known query structure). 10g enables
   ||                 us to combine DBMS_SQL with ANYDATASET/ANYTYPE methods to build
   ||                 a self-describing return structure for the first time. 
   ||
   ||              5. This utility is designed for views with LONGs only. It is not a 
   ||                 general-purpose dynamic query engine. As such, some of the type
   ||                 flexibility required of such an engine is not available. As of
   ||                 10.2.0.x, only a small number of types are used in DBA_% views
   ||                 and this utility caters for them. It also adds the code required
   ||                 to handle some additional types found in DBMS_TYPES, but these
   ||                 will be unused until at least 11g.
   ||
   ||
   || Usage:       a) Query direct from interface (entire view)
   ||              --------------------------------------------
   ||              e.g. Query DBA_VIEWS where view text contains table SOME_TABLE.
   ||
   ||              SELECT owner, view_name, text
   ||              FROM   TABLE(
   ||                        dla_pkg.query_view(
   ||                           'SELECT * FROM dba_views')
   ||                        )
   ||              WHERE  UPPER(text) LIKE '%SOME_TABLE%';
   ||
   ||              b) Query direct from interface (specific sql against view)
   ||              ----------------------------------------------------------
   ||              e.g. Query DBA_VIEWS where view text contains table SOME_TABLE.
   ||
   ||              SELECT *
   ||              FROM   TABLE(
   ||                        dla_pkg.query_view(
   ||                           'SELECT owner, view_name, text FROM dba_views')
   ||                        )
   ||              WHERE  UPPER(text) LIKE '%SOME_TABLE%';
   ||
   ||              c) Query direct from wrapper views
   ||              ----------------------------------
   ||              e.g. Query V_DBA_VIEWS where view text contains table SOME_TABLE.
   ||
   ||              SELECT owner, view_name, text
   ||              FROM   v_dba_views
   ||              WHERE  UPPER(text) LIKE '%SOME_TABLE%';
   ||
   ||              d) Use the filter APIs to restrict the function return
   ||              ------------------------------------------------------
   ||              e.g. Add filters to restrict V_DBA_VIEWS to SCOTT.SOME_VIEW
   ||
   ||              BEGIN
   ||                 dla_pkg.set_filter(p_name  => 'OWNER',
   ||                                    p_value => 'SCOTT');
   ||                 dla_pkg.set_filter(p_name  => 'VIEW_NAME',
   ||                                    p_value => 'SOME_VIEW');
   ||              END;
   ||              /
   ||
   ||              SELECT owner, view_name, text
   ||              FROM   v_dba_views;  --<-- returns 1 row only for SCOTT.SOME_VIEW
   ||              
   ||              e) Clear the filters
   ||              ------------------------------------------------------
   ||              e.g. Clear all current filters
   ||
   ||              BEGIN
   ||                 dla_pkg.clear_filter;
   ||              END;
   ||              /
   ||
   ||              e.g. Clear a specific filter
   ||
   ||              BEGIN
   ||                 dla_pkg.clear_filter( p_name  => 'OWNER',
   ||                                       p_value => 'SCOTT' );
   ||              END;
   ||              /
   ||
   ||              f) Show the current filters
   ||              ------------------------------------------------------
   ||              e.g. Using API (can alternatively use SESSION_CONTEXT)
   ||
   ||              SELECT *
   ||              FROM   TABLE(dla_pkg.show_filters);
   ||
   ||              g) Include pseudo-columns/functions
   ||              ------------------------------------------------------
   ||              e.g. ROWID, ROWNUM, LEVEL, SYSDATE, USER. These *must*
   ||                   be aliased.
   ||
   ||              SELECT *
   ||              FROM   TABLE(
   ||                        dla_pkg.query_view(
   ||                           'SELECT ROWNUM AS rn, owner, view_name, text
   ||                            FROM dba_views')
   ||                        );
   ||
   || License:     MIT License
   ||              Copyright (c) 2007 Adrian Billington, www.oracle-developer.net
   ||              See https://github.com/oracle-developer/dla/blob/master/LICENSE
   ||
   || ---------------------------------------------------------------------------------
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
   PROCEDURE set_filter(
             p_name  IN VARCHAR2,
             p_value IN VARCHAR2
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
   PROCEDURE clear_filter( 
             p_name IN VARCHAR2 DEFAULT 'ALL'
             );

   /*
   || Table function to show current filters. Alternatively,
   || query the SESSION_CONTEXT built-in view.
   */
   FUNCTION show_filters RETURN dla_filter_ntt;

   /*
   || Pipelined function interface. 
   */
   FUNCTION query_view(
            p_stmt IN VARCHAR2 
            ) RETURN ANYDATASET PIPELINED USING dla_ot;

   /*
   || Record types for use across multiple DLA_OT methods.
   */
   TYPE rt_dynamic_sql IS RECORD
   ( cursor      INTEGER
   , column_cnt  PLS_INTEGER
   , description DBMS_SQL.DESC_TAB2
   , execute     INTEGER
   );

   TYPE rt_anytype_metadata IS RECORD
   ( precision PLS_INTEGER
   , scale     PLS_INTEGER
   , length    PLS_INTEGER
   , csid      PLS_INTEGER
   , csfrm     PLS_INTEGER
   , schema    VARCHAR2(30)
   , type      ANYTYPE
   , name      VARCHAR2(30)
   , version   VARCHAR2(30)
   , attr_cnt  PLS_INTEGER
   , attr_type ANYTYPE
   , attr_name VARCHAR2(128)
   , typecode  PLS_INTEGER
   );

   /*
   || State variable for use across multiple DLA_OT methods.
   */
   r_sql rt_dynamic_sql;
   
END dla_pkg;
/

prompt Installing dla_ot type body...

CREATE TYPE BODY dla_ot AS

   /*
   || ---------------------------------------------------------------------------------
   ||
   || Name:        dla_ot
   ||
   || Description: Implementation type for dynamic Dictionary Long Application
   ||
   || License:     MIT License
   ||              Copyright (c) 2007 Adrian Billington, www.oracle-developer.net
   ||              See https://github.com/oracle-developer/dla/blob/master/LICENSE
   ||
   || ---------------------------------------------------------------------------------
   */

   ------------------------------------------------------------------------------------
   STATIC FUNCTION ODCITableDescribe(
                   rtype OUT ANYTYPE,
                   stmt  IN  VARCHAR2
                   ) RETURN NUMBER IS

      r_sql   dla_pkg.rt_dynamic_sql;
      v_rtype ANYTYPE;

  BEGIN

      /*
      || Parse the SQL and describe its format and structure.
      */
      r_sql.cursor := DBMS_SQL.OPEN_CURSOR;
      DBMS_SQL.PARSE( r_sql.cursor, stmt, DBMS_SQL.NATIVE );
      DBMS_SQL.DESCRIBE_COLUMNS2( r_sql.cursor, r_sql.column_cnt, r_sql.description );
      DBMS_SQL.CLOSE_CURSOR( r_sql.cursor );

      /*
      || Create the ANYTYPE record structure from this SQL structure.
      || Replace LONG columns with CLOB...
      */
      ANYTYPE.BeginCreate( DBMS_TYPES.TYPECODE_OBJECT, v_rtype );

      FOR i IN 1 .. r_sql.column_cnt LOOP

         v_rtype.AddAttr( r_sql.description(i).col_name,
                          CASE 
                             --<>--
                             WHEN r_sql.description(i).col_type IN (1,96,11,208)
                             THEN DBMS_TYPES.TYPECODE_VARCHAR2
                             --<>--
                             WHEN r_sql.description(i).col_type = 2
                             THEN DBMS_TYPES.TYPECODE_NUMBER
                             --<LONG defined as CLOB>--
                             WHEN r_sql.description(i).col_type IN (8,112)
                             THEN DBMS_TYPES.TYPECODE_CLOB
                             --<>--
                             WHEN r_sql.description(i).col_type = 12
                             THEN DBMS_TYPES.TYPECODE_DATE
                             --<>--
                             WHEN r_sql.description(i).col_type = 23 
                             THEN DBMS_TYPES.TYPECODE_RAW
                             --<>--
                             WHEN r_sql.description(i).col_type = 180
                             THEN DBMS_TYPES.TYPECODE_TIMESTAMP
                             --<>--
                             WHEN r_sql.description(i).col_type = 181
                             THEN DBMS_TYPES.TYPECODE_TIMESTAMP_TZ
                             --<>--
                             WHEN r_sql.description(i).col_type = 182
                             THEN DBMS_TYPES.TYPECODE_INTERVAL_YM
                             --<>--
                             WHEN r_sql.description(i).col_type = 183
                             THEN DBMS_TYPES.TYPECODE_INTERVAL_DS
                             --<>--
                             WHEN r_sql.description(i).col_type = 231
                             THEN DBMS_TYPES.TYPECODE_TIMESTAMP_LTZ
                             --<>--
                          END,
                          r_sql.description(i).col_precision,
                          r_sql.description(i).col_scale,
                          CASE r_sql.description(i).col_type
                             WHEN 11 
                             THEN 32
                             ELSE r_sql.description(i).col_max_len
                          END,
                          r_sql.description(i).col_charsetid,
                          r_sql.description(i).col_charsetform );
      END LOOP;

      v_rtype.EndCreate;

      /*
      || Now we can use this transient record structure to create a table type
      || of the same. This will create a set of types on the database for use 
      || by the pipelined function...
      */
      ANYTYPE.BeginCreate( DBMS_TYPES.TYPECODE_TABLE, rtype );
      rtype.SetInfo( NULL, NULL, NULL, NULL, NULL, v_rtype,
                     DBMS_TYPES.TYPECODE_OBJECT, 0 );
      rtype.EndCreate();

      RETURN ODCIConst.Success;

   END;

   ------------------------------------------------------------------------------------
   STATIC FUNCTION ODCITablePrepare(
                   sctx    OUT dla_ot,
                   tf_info IN  sys.ODCITabFuncInfo,
                   stmt    IN  VARCHAR2
                   ) RETURN NUMBER IS

      r_meta dla_pkg.rt_anytype_metadata;

  BEGIN

      /*
      || We prepare the dataset that our pipelined function will return by
      || describing the ANYTYPE that contains the transient record structure...
      */
      r_meta.typecode := tf_info.rettype.GetAttrElemInfo( 
                            1, r_meta.precision, r_meta.scale, r_meta.length,
                            r_meta.csid, r_meta.csfrm, r_meta.type, r_meta.name 
                            );

      /*
      || Using this, we initialise the scan context for use in this and
      || subsequent executions of the same dynamic SQL cursor...
      */
      sctx := dla_ot(r_meta.type);

      RETURN ODCIConst.Success;

   END;

   ------------------------------------------------------------------------------------
   STATIC FUNCTION ODCITableStart(
                   sctx IN OUT dla_ot,
                   stmt IN     VARCHAR2
                   ) RETURN NUMBER IS

      r_meta dla_pkg.rt_anytype_metadata;

  BEGIN

      /*
      || We now describe the cursor again and use this and the described
      || ANYTYPE structure to define and execute the SQL statement...
      */
      dla_pkg.r_sql.cursor := DBMS_SQL.OPEN_CURSOR;
      DBMS_SQL.PARSE( dla_pkg.r_sql.cursor, stmt, DBMS_SQL.NATIVE );
      DBMS_SQL.DESCRIBE_COLUMNS2( dla_pkg.r_sql.cursor,
                                  dla_pkg.r_sql.column_cnt,
                                  dla_pkg.r_sql.description );

      FOR i IN 1 .. dla_pkg.r_sql.column_cnt LOOP

         /*
         || Get the ANYTYPE attribute at this position...
         */
         r_meta.typecode := sctx.atype.GetAttrElemInfo( 
                               i, r_meta.precision, r_meta.scale, r_meta.length,
                               r_meta.csid, r_meta.csfrm, r_meta.type, r_meta.name 
                               );

         CASE r_meta.typecode
            --<>--
            WHEN DBMS_TYPES.TYPECODE_VARCHAR2
            THEN 
               DBMS_SQL.DEFINE_COLUMN(
                  dla_pkg.r_sql.cursor, i, '', 32767 
                  );
            --<>--
            WHEN DBMS_TYPES.TYPECODE_NUMBER
            THEN
               DBMS_SQL.DEFINE_COLUMN( 
                  dla_pkg.r_sql.cursor, i, CAST(NULL AS NUMBER) 
                  );
            --<>--
            WHEN DBMS_TYPES.TYPECODE_DATE
            THEN
               DBMS_SQL.DEFINE_COLUMN( 
                  dla_pkg.r_sql.cursor, i, CAST(NULL AS DATE) 
                  );
            --<>--
            WHEN DBMS_TYPES.TYPECODE_RAW
            THEN
               DBMS_SQL.DEFINE_COLUMN_RAW( 
                  dla_pkg.r_sql.cursor, i, CAST(NULL AS RAW), r_meta.length
                  );
            --<>--
            WHEN DBMS_TYPES.TYPECODE_TIMESTAMP
            THEN
               DBMS_SQL.DEFINE_COLUMN( 
                  dla_pkg.r_sql.cursor, i, CAST(NULL AS TIMESTAMP)
                  );
            --<>--
            WHEN DBMS_TYPES.TYPECODE_TIMESTAMP_TZ
            THEN
               DBMS_SQL.DEFINE_COLUMN( 
                  dla_pkg.r_sql.cursor, i, CAST(NULL AS TIMESTAMP WITH TIME ZONE)
                  );
            --<>--
            WHEN DBMS_TYPES.TYPECODE_TIMESTAMP_LTZ 
            THEN
               DBMS_SQL.DEFINE_COLUMN( 
                  dla_pkg.r_sql.cursor, i, CAST(NULL AS TIMESTAMP WITH LOCAL TIME ZONE)
                  );
            --<>--
            WHEN DBMS_TYPES.TYPECODE_INTERVAL_YM
            THEN
               DBMS_SQL.DEFINE_COLUMN(
                  dla_pkg.r_sql.cursor, i, CAST(NULL AS INTERVAL YEAR TO MONTH)
                  );
            --<>--
            WHEN DBMS_TYPES.TYPECODE_INTERVAL_DS
            THEN
               DBMS_SQL.DEFINE_COLUMN( 
                  dla_pkg.r_sql.cursor, i, CAST(NULL AS INTERVAL DAY TO SECOND)
                  );
            --<>--
            WHEN DBMS_TYPES.TYPECODE_CLOB
            THEN
               --<>--
               CASE dla_pkg.r_sql.description(i).col_type
                  WHEN 8
                  THEN 
                     DBMS_SQL.DEFINE_COLUMN_LONG(
                        dla_pkg.r_sql.cursor, i 
                        );
                  ELSE
                     DBMS_SQL.DEFINE_COLUMN( 
                        dla_pkg.r_sql.cursor, i, CAST(NULL AS CLOB)
                        );
               END CASE;
            --<>--
         END CASE;
      END LOOP;

      /*
      || The cursor is prepared according to the structure of the type we wish
      || to fetch it into. We can now execute it and we are done for this method...
      */
      dla_pkg.r_sql.execute := DBMS_SQL.EXECUTE( dla_pkg.r_sql.cursor );

      RETURN ODCIConst.Success;

   END;

   ------------------------------------------------------------------------------------
   MEMBER FUNCTION ODCITableFetch(
                   SELF   IN OUT dla_ot,
                   nrows  IN     NUMBER,
                   rws    OUT    ANYDATASET
                   ) RETURN NUMBER IS

      TYPE rt_fetch_attributes IS RECORD
      ( v2_column    VARCHAR2(32767)
      , num_column   NUMBER
      , date_column  DATE
      , clob_column  CLOB
      , raw_column   RAW(32767)
      , raw_error    NUMBER
      , raw_length   INTEGER
      , ids_column   INTERVAL DAY TO SECOND
      , iym_column   INTERVAL YEAR TO MONTH
      , ts_column    TIMESTAMP
      , tstz_column  TIMESTAMP WITH TIME ZONE
      , tsltz_column TIMESTAMP WITH LOCAL TIME ZONE
      , cvl_offset   INTEGER := 0
      , cvl_length   INTEGER
      );
      r_fetch rt_fetch_attributes;
      r_meta  dla_pkg.rt_anytype_metadata;


   BEGIN

      IF DBMS_SQL.FETCH_ROWS( dla_pkg.r_sql.cursor ) > 0 THEN

         /*
         || First we describe our current ANYTYPE instance (SELF.A) to determine
         || the number and types of the attributes...
         */
         r_meta.typecode := SELF.atype.GetInfo( 
                               r_meta.precision, r_meta.scale, r_meta.length,
                               r_meta.csid, r_meta.csfrm, r_meta.schema,
                               r_meta.name, r_meta.version, r_meta.attr_cnt 
                               );

         /*
         || We can now begin to piece together our returning dataset. We create an
         || instance of ANYDATASET and then fetch the attributes off the DBMS_SQL
         || cursor using the metadata from the ANYTYPE. LONGs are converted to CLOBs...
         */
         ANYDATASET.BeginCreate( DBMS_TYPES.TYPECODE_OBJECT, SELF.atype, rws );
         rws.AddInstance();
         rws.PieceWise();

         FOR i IN 1 .. dla_pkg.r_sql.column_cnt LOOP

            r_meta.typecode := SELF.atype.GetAttrElemInfo(
                                  i, r_meta.precision, r_meta.scale, r_meta.length, 
                                  r_meta.csid, r_meta.csfrm, r_meta.attr_type,
                                  r_meta.attr_name 
                                  );
   
            CASE r_meta.typecode
               --<>--
               WHEN DBMS_TYPES.TYPECODE_VARCHAR2
               THEN
                  DBMS_SQL.COLUMN_VALUE( 
                     dla_pkg.r_sql.cursor, i, r_fetch.v2_column
                     );
                  rws.SetVarchar2( r_fetch.v2_column );
               --<>--
               WHEN DBMS_TYPES.TYPECODE_NUMBER
               THEN
                  DBMS_SQL.COLUMN_VALUE(
                     dla_pkg.r_sql.cursor, i, r_fetch.num_column 
                     );
                  rws.SetNumber( r_fetch.num_column );
               --<>--
               WHEN DBMS_TYPES.TYPECODE_DATE
               THEN
                  DBMS_SQL.COLUMN_VALUE( 
                     dla_pkg.r_sql.cursor, i, r_fetch.date_column 
                     );
                  rws.SetDate( r_fetch.date_column );
               --<>--
               WHEN DBMS_TYPES.TYPECODE_RAW
               THEN
                  DBMS_SQL.COLUMN_VALUE_RAW( 
                     dla_pkg.r_sql.cursor, i, r_fetch.raw_column,
                     r_fetch.raw_error, r_fetch.raw_length 
                     );
                  rws.SetRaw( r_fetch.raw_column );
               --<>--
               WHEN DBMS_TYPES.TYPECODE_INTERVAL_DS
               THEN
                  DBMS_SQL.COLUMN_VALUE(
                     dla_pkg.r_sql.cursor, i, r_fetch.ids_column 
                     );
                  rws.SetIntervalDS( r_fetch.ids_column );
               --<>--
               WHEN DBMS_TYPES.TYPECODE_INTERVAL_YM
               THEN
                  DBMS_SQL.COLUMN_VALUE(
                     dla_pkg.r_sql.cursor, i, r_fetch.iym_column 
                     );
                  rws.SetIntervalYM( r_fetch.iym_column );
               --<>--
               WHEN DBMS_TYPES.TYPECODE_TIMESTAMP
               THEN
                  DBMS_SQL.COLUMN_VALUE(
                     dla_pkg.r_sql.cursor, i, r_fetch.ts_column
                     );
                  rws.SetTimestamp( r_fetch.ts_column );
               --<>--
               WHEN DBMS_TYPES.TYPECODE_TIMESTAMP_TZ
               THEN
                  DBMS_SQL.COLUMN_VALUE(
                     dla_pkg.r_sql.cursor, i, r_fetch.tstz_column 
                     );
                  rws.SetTimestampTZ( r_fetch.tstz_column );
               --<>--
               WHEN DBMS_TYPES.TYPECODE_TIMESTAMP_LTZ
               THEN
                  DBMS_SQL.COLUMN_VALUE( 
                     dla_pkg.r_sql.cursor, i, r_fetch.tsltz_column 
                     );
                  rws.SetTimestamplTZ( r_fetch.tsltz_column );
               --<>--
               WHEN DBMS_TYPES.TYPECODE_CLOB
               THEN
                  --<>--
                  CASE dla_pkg.r_sql.description(i).col_type
                     WHEN 8
                     THEN
                        LOOP
                           DBMS_SQL.COLUMN_VALUE_LONG(
                              dla_pkg.r_sql.cursor, i, 32767, r_fetch.cvl_offset, 
                              r_fetch.v2_column, r_fetch.cvl_length 
                              );
                           r_fetch.clob_column := r_fetch.clob_column || 
                                                  r_fetch.v2_column;
                           r_fetch.cvl_offset := r_fetch.cvl_offset + 32767;
                           EXIT WHEN r_fetch.cvl_length < 32767;
                        END LOOP;
                     ELSE
                        DBMS_SQL.COLUMN_VALUE(
                           dla_pkg.r_sql.cursor, i, r_fetch.clob_column 
                           );
                     END CASE;
                     rws.SetClob( r_fetch.clob_column );
               --<>--
            END CASE;
         END LOOP;
   
         /*
         || Our ANYDATASET instance is complete. We end our create session...
         */    
         rws.EndCreate();

      END IF;

      RETURN ODCIConst.Success;

   END;

   ------------------------------------------------------------------------------------
   MEMBER FUNCTION ODCITableClose(
                   SELF IN dla_ot
                   ) RETURN NUMBER IS
   BEGIN
      DBMS_SQL.CLOSE_CURSOR( dla_pkg.r_sql.cursor );
      dla_pkg.r_sql := NULL;
      RETURN ODCIConst.Success;
   END;

END;
/

prompt Installing dla_pkg package body...

CREATE PACKAGE BODY dla_pkg AS

   /*
   || ---------------------------------------------------------------------------------
   ||
   || Name:        dla_pkg
   ||
   || Description: See package specification for details.
   ||
   || License:     MIT License
   ||              Copyright (c) 2007 Adrian Billington, www.oracle-developer.net
   ||              See https://github.com/oracle-developer/dla/blob/master/LICENSE
   ||
   || ---------------------------------------------------------------------------------
   */

   -----------------------------------------------------------------------------------
   FUNCTION filter_is_valid( p_name IN VARCHAR2 ) RETURN BOOLEAN IS
   BEGIN
      RETURN (UPPER(p_name) IN ('OWNER', 'TABLE_NAME', 'VIEW_NAME',
                                'COLUMN_NAME','CONSTRAINT_NAME','TRIGGER_NAME',
                                'PARTITION_NAME','SUBPARTITION_NAME')); 
   END filter_is_valid;

   -----------------------------------------------------------------------------------
   PROCEDURE invalid_filter( p_name IN VARCHAR2 ) IS
   BEGIN
      RAISE_APPLICATION_ERROR( -20000, p_name || ' not a valid filter' );
   END invalid_filter;

   -----------------------------------------------------------------------------------
   PROCEDURE set_filter( p_name  IN VARCHAR2,
                         p_value IN VARCHAR2 ) IS
   BEGIN
      IF filter_is_valid(p_name) THEN
         DBMS_SESSION.SET_CONTEXT( 'dla_ctx', p_name, p_value );
      ELSE
         invalid_filter(p_name);
      END IF;
   END set_filter;

   -----------------------------------------------------------------------------------
   PROCEDURE clear_filter( p_name IN VARCHAR2 DEFAULT 'ALL' ) IS
   BEGIN
      IF UPPER(p_name) = 'ALL' THEN
         DBMS_SESSION.CLEAR_ALL_CONTEXT( 'dla_ctx' );
      ELSIF filter_is_valid(p_name) THEN
         DBMS_SESSION.CLEAR_CONTEXT( 'dla_ctx', NULL, p_name );
      ELSE
         invalid_filter(p_name);
      END IF;
   END clear_filter;

   -----------------------------------------------------------------------------------
   FUNCTION show_filters RETURN dla_filter_ntt IS

      nt_filters dla_filter_ntt;

   BEGIN

      /*
      || Use SESSION_CONTEXT view rather than DBMS_SESSION.LIST_CONTEXT
      || in case other contexts are heavily used...
      */
      SELECT dla_filter_ot(attribute, value) BULK COLLECT INTO nt_filters
      FROM   session_context
      WHERE  UPPER(namespace) = 'DLA_CTX';

      RETURN nt_filters;

   END show_filters;

   -----------------------------------------------------------------------------------

END dla_pkg;
/


prompt Installing views...

CREATE VIEW v_dba_constraints
AS 
   SELECT *
   FROM   TABLE(
             dla_pkg.query_view(
                q'[select *
                   from   dba_constraints
                   where (   owner = sys_context('dla_ctx','owner')
                          or sys_context('dla_ctx','owner') is null )
                   and   (   table_name = sys_context('dla_ctx','table_name')
                          or sys_context('dla_ctx','table_name') is null )
                   and   (   constraint_name = sys_context('dla_ctx','constraint_name')
                          or sys_context('dla_ctx','constraint_name') is null )]'
                 ));

CREATE VIEW v_dba_tab_columns
AS 
   SELECT *
   FROM   TABLE(
             dla_pkg.query_view(
                q'[select *
                   from   dba_tab_columns
                   where (   owner = sys_context('dla_ctx','owner')
                          or sys_context('dla_ctx','owner') is null )
                   and   (   table_name = sys_context('dla_ctx','table_name')
                          or sys_context('dla_ctx','table_name') is null )
                   and   (   column_name = sys_context('dla_ctx','column_name')
                          or sys_context('dla_ctx','column_name') is null )]'
                ));

CREATE VIEW v_dba_tab_partitions
AS 
   SELECT *
   FROM   TABLE(
             dla_pkg.query_view(
                q'[select *
                   from   dba_tab_partitions
                   where (   table_owner = sys_context('dla_ctx','owner')
                          or sys_context('dla_ctx','owner') is null )
                   and   (   table_name = sys_context('dla_ctx','table_name')
                          or sys_context('dla_ctx','table_name') is null )
                   and   (   partition_name = sys_context('dla_ctx','partition_name')
                          or sys_context('dla_ctx','partition_name') is null )]'
                ));

CREATE VIEW v_dba_tab_subpartitions
AS 
   SELECT *
   FROM   TABLE(
             dla_pkg.query_view(
                q'[select *
                   from   dba_tab_subpartitions
                   where (   table_owner = sys_context('dla_ctx','owner')
                          or sys_context('dla_ctx','owner') is null )
                   and   (   table_name = sys_context('dla_ctx','table_name')
                          or sys_context('dla_ctx','table_name') is null )
                   and   (   partition_name = sys_context('dla_ctx','partition_name')
                          or sys_context('dla_ctx','partition_name') is null )
                   and   (   subpartition_name = sys_context('dla_ctx','subpartition_name')
                          or sys_context('dla_ctx','subpartition_name') is null )]'
                 ));

CREATE VIEW v_dba_triggers
AS 
   SELECT *
   FROM   TABLE(
             dla_pkg.query_view(
                q'[select *
                   from   dba_triggers
                   where (   owner = sys_context('dla_ctx','owner')
                          or sys_context('dla_ctx','owner') is null )
                   and   (   table_name = sys_context('dla_ctx','table_name')
                          or sys_context('dla_ctx','table_name') is null )
                   and   (   trigger_name = sys_context('dla_ctx','trigger_name')
                          or sys_context('dla_ctx','trigger_name') is null )]'
                ));

CREATE VIEW v_dba_views
AS 
   SELECT *
   FROM   TABLE(
             dla_pkg.query_view(
                q'[select *
                   from   dba_views
                   where (   owner = sys_context('dla_ctx','owner')
                          or sys_context('dla_ctx','owner') is null )
                   and   (   view_name = sys_context('dla_ctx','view_name')
                          or sys_context('dla_ctx','view_name') is null )]'
                 ));

prompt Installing synonyms and privileges...
create or replace public synonym dla_pkg for dla_pkg;
grant execute on dla_pkg to public;

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
