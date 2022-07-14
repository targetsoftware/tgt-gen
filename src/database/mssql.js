const log = require('node-pretty-log');
const sql = require('mssql')

let client;

module.exports = {
    async getClient(config) {
        if (!client || !client.connected)
            client = await sql.connect(config.db_config);
        return client;
    },
    async getTableColumns(tables, config) {

        log('info', `Consulting table columns...`)

        const client = await this.getClient(config);

        const _tables = this.formatTableArrayString(tables);
        const _query = `SELECT
                            '' AS table_schema
                            ,dbo.sysobjects.name AS table_name
                            ,dbo.syscolumns.name AS column_name
                            ,dbo.syscolumns.isnullable AS is_nullable
                            ,dbo.systypes.name AS data_type
                            ,dbo.systypes.name AS data_type_original
                            ,dbo.systypes.name AS data_type_full
                            ,dbo.syscolumns.length AS maximum_length
                            ,dbo.syscolumns.prec AS numeric_precision
                            ,dbo.syscolumns.colorder AS position
                        FROM dbo.syscolumns
                        INNER JOIN dbo.sysobjects
                        ON dbo.syscolumns.id = dbo.sysobjects.id
                        INNER JOIN dbo.systypes
                        ON dbo.syscolumns.xtype = dbo.systypes.xtype
                        WHERE (dbo.sysobjects.name IN (${_tables}))
                        AND (dbo.systypes.status <> 1)
                        ORDER BY dbo.sysobjects.name,
                        dbo.syscolumns.colorder `;

        const { recordset } = await client.request()
            .query(_query);

        return recordset;
    },
    async getKeys(tables, config) {

        log('info', `Consulting keys column...`)

        const client = await this.getClient(config);

        const _tables = this.formatTableArrayString(tables);
        const _query = `SELECT
                            TB_PRIMARYS.TableName AS table_name
                        ,TB_PRIMARYS.ColumnName AS column_name
                        FROM (SELECT
                                i.name AS IndexName
                            ,OBJECT_NAME(ic.OBJECT_ID) AS TableName
                            ,COL_NAME(ic.OBJECT_ID, ic.column_id) AS ColumnName
                            ,i.is_primary_key
                            FROM sys.indexes AS i
                            INNER JOIN sys.index_columns AS ic
                                ON i.OBJECT_ID = ic.OBJECT_ID
                                AND i.index_id = ic.index_id
                            WHERE i.is_primary_key = 1) AS TB_PRIMARYS
                        WHERE TB_PRIMARYS.TableName IN (${_tables})`;

        const { recordset } = await client.request()
            .query(_query);

        return recordset;
    },
    async getRelatedTables(tables, config) {

        log('info', `Consulting related tabled...`)

        const client = await this.getClient(config);

        const _tables = this.formatTableArrayString(tables);
        const _query = `SELECT
                            obj.name AS FK_NAME
                            ,sch.name AS [schema_name]
                            ,tab1.name AS [table_name]
                            ,col1.name AS [column_name]
                            ,tab2.name AS [referenced_table_name]
                            ,col2.name AS [referenced_column_name]
                            FROM sys.foreign_key_columns fkc
                            INNER JOIN sys.objects obj
                                ON obj.object_id = fkc.constraint_object_id
                            INNER JOIN sys.tables tab1
                                ON tab1.object_id = fkc.parent_object_id
                            INNER JOIN sys.schemas sch
                                ON tab1.schema_id = sch.schema_id
                            INNER JOIN sys.columns col1
                                ON col1.column_id = parent_column_id
                                    AND col1.object_id = tab1.object_id
                            INNER JOIN sys.tables tab2
                                ON tab2.object_id = fkc.referenced_object_id
                            INNER JOIN sys.columns col2
                                ON col2.column_id = referenced_column_id
                                    AND col2.object_id = tab2.object_id
                            WHERE tab1.name IN (${_tables})`;

        const { recordset } = await client.request()
            .query(_query);

        return recordset;
    },
    async closeConnection() {
        await client.close()
    },
    formatTableArrayString(tables) {
        let _tables = "";
        tables.forEach(table => { _tables += `'${table}',`; });
        _tables = _tables.slice(0, -1);
        return _tables;
    }
}