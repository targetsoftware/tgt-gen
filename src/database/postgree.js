const log = require('node-pretty-log');
const { Client } = require('pg')

module.exports = {
    getClient(config) {
        // "db_config": {
        //     "connectionString": "postgres://ldollvydbuvvur:d3543cd4c422f56ecb5aaa3e68d9082866ca2013964ce9b1c6a882a5686f74d4@ec2-52-86-56-90.compute-1.amazonaws.com:5432/d8ijm06r5pna33",
        //     "ssl": {
        //         "rejectUnauthorized": false
        //     }
        // },
        return new Client({
            connectionString: config.db_config.connection_string,
            ssl: {
                rejectUnauthorized: false
            }
        });
    },
    async getTableColumns(tables, config) {

        log('info', `Consulting table columns...`)

        const client = this.getClient(config);

        await client.connect();

        const { rows } = await client.query('SELECT ' +
            'table_schema AS table_schema, ' +
            'table_name AS table_name, ' +
            'column_name AS column_name, ' +
            'is_nullable AS is_nullable, ' +
            'udt_name AS data_type, ' +
            'udt_name AS data_original, ' +
            'data_type AS data_type_full, ' +
            'character_maximum_length AS maximum_length, ' +
            'numeric_precision AS numeric_precision, ' +
            'ordinal_position AS position ' +
            'FROM information_schema.columns ' +
            'WHERE table_name = ANY($1)', [tables]);

        await client.end();

        return rows;

    },
    async getKeys(tables, config) {

        log('info', `Consulting keys column...`)

        const client = this.getClient(config);

        await client.connect();

        const { rows } = await client.query('SELECT c.column_name, c.table_name ' +
            'FROM information_schema.table_constraints tc ' +
            'JOIN information_schema.constraint_column_usage AS ccu USING (constraint_schema, constraint_name) ' +
            'JOIN information_schema.columns AS c ON c.table_schema = tc.constraint_schema ' +
            'AND tc.table_name = c.table_name AND ccu.column_name = c.column_name ' +
            'WHERE tc.table_name = ANY($1)', [tables]);

        await client.end();

        return rows;

    },
    async getRelatedTables(tables) {
        throw "[getRelatedTables] Not implemented";
    }
}