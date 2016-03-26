
# DICTIONARY LONG APPLICATION

## Contents
```
1.0 Introduction
2.0 Included Versions
   2.1 Static Version
   2.2 Dynamic Version
3.0 Installation & Removal
   3.1 Installation Prerequisites
      3.1.1 Static Version
      3.2.1 Dynamic Version
   3.2 Installation
      3.2.1 Static Version
      3.2.2 Dynamic Version
   3.3 Removal
      3.3.1 Static Version
      3.3.2 Dynamic Version
4.0 License
```
  
### 1.0 Introduction
This archive contains two versions of the Dictionary Long Application. This application provides wrappers to the DBA_% views that contain LONG columns. The wrappers are pipelined functions, which themselves are further wrapped in V_DBA_% views for ease. The LONG columns are converted to CLOBs by the application, which means they can be searched in SQL and manipulated using any built-in or user string functions that support CLOBs. 

Examples of how this application might be used:

   ```
   SELECT *
   FROM   v_dba_tab_partitions 
   WHERE  high_value LIKE '%search_string%';
   ```

   ```
   SELECT SUBSTR(text,1,100) 
   FROM   v_dba_views
   WHERE  text LIKE '%search_string%';
   ```

   ...and so on.

  
### 2.0 Included Versions
There are two versions of the application:

#### 2.1 Static Version
This has been developed on 9.2 and is for 9.2 and 10.1 databases. It can be used in later versions of Oracle, but a special dynamic version has been created for 10.2+ (see Section 2.2 below) to cater for changes to the underlying DBA_% views in newer releases.

This version encapsulates a small number of DBA_% views in static pipelined functions. This application includes the following:

* application context
* object types (1 per DBA_% view)
* collection types (1 per DBA_% view)
* package of pipelined functions (1 function per DBA_% view)
* views (1 per pipelined function)
* public synonyms and grants

It currently supports (i.e. wraps and converts) the following views: 

* `DBA_CONSTRAINTS`
* `DBA_TAB_COLUMNS` ***
* `DBA_TAB_PARTITIONS`
* `DBA_TAB_SUBPARTITIONS`
* `DBA_TRIGGERS`
* `DBA_VIEWS`

*** Note that `DBA_TAB_COLUMNS` has an additional `HISTOGRAMS` column in 10g Release 1. This column is excluded from this application to enable it to run on both 9i and 10g.

The following views (with LONGs) are excluded, but can be easily added using the existing method as templates:

**Oracle 9.2**

* `DBA_CLUSTER_HASH_EXPRESSIONS`
* `DBA_IND_EXPRESSIONS`
* `DBA_IND_PARTITIONS`
* `DBA_IND_SUBPARTITIONS`
* `DBA_MVIEWS`
* `DBA_MVIEW_AGGREGATES`
* `DBA_MVIEW_ANALYSIS`
* `DBA_OUTLINES`
* `DBA_REGISTERED_MVIEWS`
* `DBA_REGISTERED_SNAPSHOTS`
* `DBA_SNAPSHOTS`
* `DBA_SUBPARTITION_TEMPLATES`
* `DBA_SUMMARIES`
* `DBA_SUMMARY_AGGREGATES`
* `DBA_TAB_COLS`

**Oracle 10.1**

As above, plus:

* `DBA_NESTED_TABLE_COLS`
* `DBA_SQLTUNE_PLANS`

See the package specification in the installer for more details and usage examples.

#### 2.2 Dynamic Version
This has been developed on 10.2 and uses Oracle Data Cartridge to implement pipelined functions using `ANYDATASET`. This method means that the code does not need to be modified as the dictionary views change in later versions.

This version of the application is for 10.2 databases and greater.

Semantically and syntactically, this application should run on 10.1.x databases, but there is an ORA-0600 error which appears to be a bug in the way `ANYDATASET` fetches CLOBs. The error is: `ORA-00600: internal error code, arguments: [kokegPinLob1], [], [], [], [], [], [], []`. For this reason, it is recommended that the static version of the Dictionary Long Application is used for versions less than 10.2.0.1.

The dynamic version of the application uses the following:

* application context
* object types
* collection type
* package
* views (1 per underlying DBA_% view)

For each unique query passed through the application, Oracle will generate two additional types (one object type to describe the return record structure and a collection type of this object).

The dynamic version currently supports any dictionary views with LONGs by supplying the interface pipelined function to run any query. Wrapper views are provided for the following:

* `DBA_CONSTRAINTS`        [`V_DBA_CONSTRAINTS`]
* `DBA_TAB_COLUMNS`        [`V_DBA_TAB_COLUMNS`]
* `DBA_TAB_PARTITIONS`     [`V_DBA_TAB_PARTITIONS`]
* `DBA_TAB_SUBPARTITIONS`  [`V_DBA_TAB_SUBPARTITIONS`]
* `DBA_TRIGGERS`           [`V_DBA_TRIGGERS`]
* `DBA_VIEWS`              [`V_DBA_VIEWS`]


See the package specification for more details and usage examples.

### 3.0 Installation & Removal

#### 3.1 Installation Prerequisites
It is recommended that this application is installed in a "TOOLS" schema, but whichever schema is used requires the following:

##### 3.1.1 Static Version

* `CREATE ANY CONTEXT`
* `DROP ANY CONTEXT`
* `CREATE TYPE`
* `CREATE PACKAGE`
* `CREATE VIEW`
* `CREATE PUBLIC SYNONYM`
* `SELECT ON DBA_CONSTRAINTS`
* `SELECT ON DBA_VIEWS`
* `SELECT ON DBA_TAB_PARTITIONS`
* `SELECT ON DBA_TAB_SUBPARTITIONS`
* `SELECT ON DBA_TRIGGERS`
* `SELECT ON DBA_TAB_COLUMNS`
  
Note that SELECT ANY DICTIONARY can be granted in place of the specific DBA_% view grants above. 

##### 3.1.2 Dynamic Version

* `CREATE ANY CONTEXT`
* `DROP ANY CONTEXT`
* `CREATE TYPE`
* `CREATE PACKAGE`
* `CREATE VIEW`
* `CREATE PUBLIC SYNONYM`
* `SELECT ANY DICTIONARY` (or SELECT on specific views as required)

#### 3.2 Installation
The Dictionary Long Application can be installed using sqlplus or any tools that fully support sqlplus commands. There are separate install scripts depending on version, as follows.

##### 3.2.1 Static Version

1. Ensure you are connected to a database of version 9.2 or greater.
2. In sqlplus, run `install_static_dla.sql` as the application owner.
3. A warning will prompt for continue/cancel.

##### 3.2.2 Dynamic Version

1. Ensure you are connected to a database of version 10.2 or greater.
2. In sqlplus, run `install_dynamic_dla.sql` as the application owner.
3. A warning will prompt for continue/cancel.

#### 3.3 Removal
To remove the Dictionary Long Application, use the relevant version as follows:

##### 3.3.1 Static Version

1. In sqlplus, run `remove_static_dla.sql` as the application owner.
2. A warning will prompt for continue/cancel.

##### 3.3.2 Dynamic Version

1. In sqlplus, run `remove_dynamic_dla.sql` as the application owner.
2. A warning will prompt for continue/cancel.

  
### 4.0 License
This project uses the [MIT License](https://github.com/oracle-developer/dla/blob/master/LICENSE)
