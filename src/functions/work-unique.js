const log = require('node-pretty-log');

const replace = require('./replace')
const workColumn = require('./work-column')

module.exports = {
    async execute(template, context, table) {

        try {

            template = replace.contextProps(template, context);

            if (table) {
                template = replace.tableProps(template, table);
            }

            const template_lines = template.split(/\r\n|\n/);

            let index_line = 0
            let template_formated = "";

            while (index_line < template_lines.length) {

                let line = template_lines[index_line];

                if (line.indexOf("#start foreach_table_column#") >= 0 && table) {

                    index_line++;
                    line = "";

                    let template_table = "";
                    while (index_line < template_lines.length) {

                        let line_table_column_foreach = template_lines[index_line];
                        index_line++;

                        if (line_table_column_foreach.indexOf("#end foreach_table_column#") >= 0)
                            break;

                        template_table += line_table_column_foreach + (line_table_column_foreach.endsWith("\n") ? "" : "\n");
                    }

                    let line_table_column = await workColumn.execute(table, template_table);
                    if (line_table_column)
                        line += line_table_column;
                }

                else if (line.indexOf("#start foreach_table#") >= 0) {
                    index_line++;
                    line = "";

                    let template_table = "";

                    while (index_line < template_lines.length) {

                        let line_table_foreach = template_lines[index_line];
                        index_line++;

                        if (line_table_foreach.indexOf("#end foreach_table#") >= 0)
                            break;

                        template_table += line_table_foreach + (line_table_foreach.endsWith("\n") ? "" : "\n");
                    }

                    for (const _table of context.tables) {

                        let template_table_formated = template_table;
                        template_table_formated = replace.tableProps(template_table_formated, _table);

                        let index_table_line = 0;
                        const lines_table_new = template_table_formated.split(/\r\n|\n/);
                        let template_table_new = "";

                        while (index_table_line < lines_table_new.length) {

                            let line_table = lines_table_new[index_table_line];
                            if (line_table.indexOf("#start foreach_table_column#") >= 0) {
                                index_table_line++;
                                line_table = "";

                                let template_table_column = "";
                                while (index_table_line < lines_table_new.length) {

                                    let line_table_column_foreach = lines_table_new[index_table_line];
                                    index_table_line++;

                                    if (line_table_column_foreach.indexOf("#end foreach_table_column#") >= 0)
                                        continue;

                                    template_table_column += line_table_column_foreach + (line_table_column_foreach.endsWith("\n") ? "" : "\n");
                                }

                                let line_table_column = await workColumn.execute(_table, template_table_column);
                                if (line_table_column)
                                    line_table += line_table_column;
                            }
                            else
                                index_table_line++;

                            template_table_new += line_table
                        }

                        line += template_table_new + (template_table_new.endsWith("\n") ? "" : "\n");
                    }
                }
                else
                    index_line++;

                template_formated += line + (line.endsWith("\n") ? "" : "\n");

            }

            return template_formated;
        } catch (error) {
            log('error', `Failed table ${table?.name} - ${error}`)
            throw error;
        }
    }
}