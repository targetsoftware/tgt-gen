#!/usr/bin/env node

const start = require('./src/start')
const program = require('commander');

const log = require('node-pretty-log');
const hjson = require('hjson');
const fse = require('fs-extra')
const path = require('path');

const package = require('./package.json');
program.version(package.version);

program
    .command('start')
    .description('Start generador')
    .action(async () => {

        log('info', 'Starting...');

        const configPath = path.join(process.cwd(), '/generator/config.json');
        log('info', `Loading config file from ${configPath}`);

        const configText = await fse.readFile(configPath, 'utf8');
        const config = hjson.parse(configText);

        await config.contexts.forEach(async context => {
            await start(context.id, config);
        });
    });

program.parse(process.argv);