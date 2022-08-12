
const replace = require('./replace')

module.exports = {
    async execute(table, columns, template_table) {

        let line = "";

        for (const column of columns) {

            let template_table_column = replace.columnProps(template_table, column);

            template_table_column = replace.replaceFullCondictional(template_table_column, column, "data_type");

            template_table_column = replace.replaceInlineCondictional(template_table_column, 'table_column_data_type', column.data_type);
            template_table_column = replace.replaceInlineCondictional(template_table_column, 'table_column_is_nullable', !!column.is_nullable);

            line += template_table_column;
        }
        return line;
    }
}