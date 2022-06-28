
String.prototype.toPascalCase = function () { return this.replace(/_/g, " ").replace(/(^|\s)\S/g, l => l.toUpperCase()).replace(/\s/g, ""); }
String.prototype.toSnakeCase = function () { return this.replace(/_/g, " ").replace(/\s/g, "_").toLowerCase(); }
String.prototype.toKebabCase = function () { return this.replace(/_/g, " ").replace(/\s/g, "-").toLowerCase(); }
String.prototype.toCamelCase = function () { return this.toPascalCase().charAt(0).toLowerCase() + this.toPascalCase().slice(1); }
String.prototype.toSpaceUpperCase = function () { return this.replace(/_/g, " ").replace(/(^|\s)\S/g, l => l.toUpperCase()); }


module.exports = {
    contextProps(value, context) {
        value = this.replaceProps(value, context, "name_space", "context_name_space");
        value = this.replaceProps(value, context, "module", "context_module");
        return value;
    },
    tableProps(value, table) {
        value = this.replaceProps(value, table, "name", "table_name");
        value = this.replaceProps(value, table, "name_formated", "table_name_formated");
        value = this.replaceProps(value, table, "primary_key_name", "table_primary_key_name");
        value = this.replaceProps(value, table, "primary_key_data_type", "table_primary_key_data_type");
        return value;
    },
    contextAndTableProps(value, context, table) {
        value = this.contextProps(value, context);
        value = this.tableProps(value, table);
        return value;
    },
    columnProps(value, column) {
        value = this.replaceProps(value, column, "column_name", "table_column_name");
        value = this.replaceProps(value, column, "column_name_original", "table_column_name_original");
        value = this.replaceProps(value, column, "column_name_formated", "table_column_name_formated");
        value = this.replaceProps(value, column, "data_type", "table_column_data_type");
        value = this.replaceProps(value, column, "data_type_original", "table_column_data_type_original");
        return value;
    },
    replaceProps(value, obj, prop, tag) {
        value = value.replace(new RegExp('<#' + tag + '#>', 'g'), obj[prop])
        value = value.replace(new RegExp('<#' + tag + '_pascalcase#>', 'g'), obj[prop].toPascalCase())
        value = value.replace(new RegExp('<#' + tag + '_snakecase#>', 'g'), obj[prop].toSnakeCase())
        value = value.replace(new RegExp('<#' + tag + '_kebabcase#>', 'g'), obj[prop].toKebabCase())
        value = value.replace(new RegExp('<#' + tag + '_camelcase#>', 'g'), obj[prop].toCamelCase())
        value = value.replace(new RegExp('<#' + tag + '_lowercase#>', 'g'), obj[prop].toLowerCase())
        value = value.replace(new RegExp('<#' + tag + '_spacecase#>', 'g'), obj[prop].toSpaceUpperCase())
        return value;
    },
    replaceInlineCondictional(value, tag, condictional) {
        const value_condictional = value.match(new RegExp('(?<=<#' + tag + ')(.*?)(?=#>)', 'g'));
        if (value_condictional) {
            value_condictional.map(val => {
                let condictional_compare = val.split(" ")[0];
                let true_false = val.replace(condictional_compare, "").trim().slice(1, -1).split("|");
                let val_new = "";
                if (condictional.toString() == condictional_compare.replace("=", "").toString()) val_new = true_false[0];
                else val_new = true_false[1] ?? "";
                value = value.replace(`<#${tag}${condictional_compare}${val.replace(condictional_compare, "")}#>`, val_new);// .replace(new RegExp('(?=<#' + tag + ')(.*?)(?<=#>)', 'g'), val_new);
            });
        }

        return value;
    },
    replaceFullCondictional(template_table, column, field) {

        let template_table_new = template_table;

        const template_table_column_lines = template_table_new.split(/\r\n|\n/);
        let template_table_column = "";
        let index_column_line = 0;

        while (index_column_line < template_table_column_lines.length) {

            let template_table_column_foreach = template_table_column_lines[index_column_line];
            index_column_line++;

            const if_field = `if_column_${field}`;
            if (template_table_column_foreach.indexOf(`#start ${if_field}`) >= 0) {

                let field_template = /\(([^)]+)\)/.exec(template_table_column_foreach)[1];
                let has_field = field_template.split(';').indexOf(column[field]) >= 0;

                template_table_column_foreach = "";

                let next_column_line = template_table_column_lines[index_column_line]
                while (next_column_line.indexOf(`#end ${if_field}`) < 0) {
                    if (has_field)
                        template_table_column_foreach += next_column_line + (next_column_line.endsWith("\n") ? "" : "\n");

                    index_column_line++;
                    next_column_line = template_table_column_lines[index_column_line];
                }

                if (!template_table_column_foreach)
                    continue;

            }
            else if (template_table_column_foreach.indexOf(`#end ${if_field}`) >= 0)
                continue;

            if (template_table_column_foreach)
                template_table_column += template_table_column_foreach + (template_table_column_foreach.endsWith("\n") ? "" : "\n");
        }

        return template_table_column;
    },
}