# Target Software - Generator

Code generator, independent, without language or technology coupling, based on templates and files, directed to your database tables.

## Installation

Use the package manager [npm + node.js](https://nodejs.org/en/download/) to install and run `tgt-gen`.

```bash
npm install @targetsoftware/tgt-gen --global
```

## Usage

Inside the root folder of your project, create a folder `generator` and inside it create the `config.json` file and the `templates` folder to start, and run command
```bash
tgt-gen start
```

## Templates
In the project they are creating templates for Vue.js 2 and Asp.Net in CQRS

## DB Connection
Connection is available for SQL Server and Postgree

## Example `config.json` 


```json
{
	"db_type": "mssql", //mssql or postgree
	"db_config": {
		"user": "<db_user>",
		"password": "<db_password>",
		"database": "<db_name>",
		"server": "<db_server>",
		"options": {
			"encrypt": true // options from node connector
		}
	},
	"contexts": [
		{
			"id": "frontend_core",
			"name_space": "Project.Ui",
			"module": "Core",
			"root_path": "C:/Projetos/base-generator/example_front",
			"template_path": "C:/Projetos/base-generator/templates/front/vue",
			"tables": [
				{
					"name": "Pessoa"
				},
				{
					"name": "Simulado"
				},
				{
					"name": "Plano"
				}
			],
			"data_type": {
				"uniqueidentifier": "String",
				"varchar": "String",
				"nchar": "String",
				"nvarchar": "String",
				"text": "String",
				"date": "Date",
				"datetime": "Date",
				"bigint": "Number",
				"int": "Number",
				"smallint": "Number",
				"int16": "Number",
				"numeric": "Number",
				"decimal": "Number",
				"money": "Number",
				"float": "Number",
				"bit": "Boolean",
				"tinyint": "Boolean"
			},
			"works": [
				{
					"path": "/src/router",
					"file_name": "generated.js",
					"template_file": "./router.tpl",
					"replace_if_exists": true
				},
				{
					"path": "/src/views/<#table_name_kebabcase#>",
					"file_name": "<#table_name_kebabcase#>-index.vue",
					"template_file": "./view-index.tpl",
					"per_table": true,
					"replace_if_exists": true
				},
				{
					"path": "/src/views/<#table_name_kebabcase#>",
					"file_name": "<#table_name_kebabcase#>-create.vue",
					"template_file": "./view-create.tpl",
					"per_table": true,
					"replace_if_exists": true
				},
				{
					"path": "/src/views/<#table_name_kebabcase#>",
					"file_name": "<#table_name_kebabcase#>-edit.vue",
					"template_file": "./view-edit.tpl",
					"per_table": true,
					"replace_if_exists": true
				},
				{
					"path": "/src/views/<#table_name_kebabcase#>",
					"file_name": "<#table_name_kebabcase#>-form-create.vue",
					"template_file": "./view-form-create.tpl",
					"per_table": true,
					"replace_if_exists": true
				},
				{
					"path": "/src/views/<#table_name_kebabcase#>",
					"file_name": "<#table_name_kebabcase#>-form-edit.vue",
					"template_file": "./view-form-edit.tpl",
					"per_table": true,
					"replace_if_exists": true
				}
			]
		}
	]
}
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)