const log = require('node-pretty-log');
const fse = require('fs-extra')
const path = require('path');

const database_mssql = require('./database/mssql')
const database_postgree = require('./database/postgree')

const replace = require('./functions/replace')
const workUnique = require('./functions/work-unique')

module.exports = async function start(id, config) {

    const context = config.contexts.find(_ => _.id == id);

    log('info', `Runing context ${context.id} - ${context.name_space}.${context.module}`);

    try {

        if (!context.tables || context.tables.length == 0)
            throw `tables undefined`;

        const uniq = context.tables
            .map(table => { return { count: 1, name: table.name } })
            .reduce((result, b) => {
                result[b.name] = (result[b.name] || 0) + b.count;
                return result;
            }, {});
        const duplicates = Object.keys(uniq).filter((a) => uniq[a] > 1);
        if (duplicates && duplicates.length > 0)
            throw `Has duplicate table names ${duplicates}`;

        const tables_name = context.tables.map(_ => _.name)

        const database = config.db_type == "mssql" ? database_mssql : database_postgree;

        let result_columns = await database.getTableColumns(tables_name, config);
        let result_keys = await database.getKeys(tables_name, config);
        let result_related_tables = await database.getRelatedTables(tables_name, config);
        await database.closeConnection();

        if (!context.works_include || context.works_include.length == 0)
            context.works_include = context.works.map(_ => _.name);

        // MAP COLUMNS TO CONTEXT TABLES OBJECT
        log('info', `Setting table properties`);
        context.tables.forEach(table => {

            try {

                if (!table.name_formated)
                    table.name_formated = table.name.toSpaceUpperCase();

                const columns = result_columns.filter(_ => _.table_name == table.name);
                table.columns = columns.sort((a, b) => a.position - b.position);

                const related_tables = result_related_tables.filter(_ => _.table_name == table.name);
                table.related_tables = related_tables;

                table.columns.forEach(column => {

                    column.column_name_original = column.column_name;

                    if (!column.column_name_formated)
                        column.column_name_formated = column.column_name.toSpaceUpperCase();

                    const related_column_tables = table.related_tables.filter(_ => _.column_name == column.column_name);
                    table.related_column_tables = related_column_tables;

                    const data_type_new = context.data_type[column.data_type];
                    if (data_type_new) column.data_type = data_type_new;

                    const is_primary_key = result_keys.filter(_ => _.table_name == column.table_name && _.column_name == column.column_name).length > 0;
                    if (is_primary_key) {
                        column.is_primary_key = true;
                        if (column.column_name.toLowerCase() == "id") {
                            const column_name_new = column.table_name + (column.column_name == "id" ? ("_" + column.column_name) : column.column_name);
                            log('warn', `Primary key from table ${column.table_name} is "${column.column_name}", changing to ${column_name_new}`);
                            column.column_name = column_name_new;
                        }

                        table.primary_key_name = column.column_name;
                        table.primary_key_data_type = column.data_type;
                    }

                });

                if (!table.works_include || table.works_include.length == 0)
                    table.works_include = context.works_include;

                if (table.works_exclude && table.works_exclude.length > 0)
                    table.works_include = table.works_include.filter(work => !table.works_exclude.includes(work));

                if (!table.primary_key_name)
                    throw `Table ${table.name} do not have primary_key`;

                log('Success', `Table ${table.name} configured.`);

            } catch (error) {
                log('error', `Setting table properties: ${error}`);
                throw error;
            }

        });

        // WORKS
        log('info', `Start workings`);
        context.works.forEach(async work => {

            let template = await fse.readFile(path.join(context.template_path, work.template_file), 'utf8');
            const full_path = path.join(context.root_path, work.path);

            if (work.per_table) {
                log('info', `Working with ${work.template_file} - One file per table...`);
                for (const table of context.tables) {

                    if (!table.works_include.includes(work.name)) {
                        log('info', `${table.name} - Skipped because it wasn't included`)
                        continue;
                    }

                    let full_path_formated = replace.contextAndTableProps(full_path, context, table);
                    let file_name_formated = replace.contextAndTableProps(work.file_name, context, table);

                    await fse.ensureDir(full_path_formated);
                    let template_formated = await workUnique.execute(work, template, context, table);
                    await fse.writeFile(path.join(full_path_formated, file_name_formated), template_formated);

                    log('success', `${table.name} - File generated ${full_path_formated}`)
                }
            }
            else {
                log('info', `Working with ${work.template_file} - Unique file...`);

                await fse.ensureDir(full_path);
                let template_formated = await workUnique.execute(work, template, context);
                let full_path_formated = path.join(full_path, work.file_name);
                await fse.writeFile(full_path_formated, template_formated);
                log('success', `File generated ${full_path_formated}`)
            }

        });


    } catch (error) {
        log('error', error);
        throw error;
    }

}

