
const start = require('./src/start')
const program = require('commander');

const package = require('./package.json');
program.version(package.version);

program
    .command('start')
    .description('Start generador')
    .action(() => {

        const config = require(process.cwd() + '/generator/config.json')

        config.contexts.forEach(async context => {
            await start(context.id, config);
        });
    });

program.parse(process.argv);