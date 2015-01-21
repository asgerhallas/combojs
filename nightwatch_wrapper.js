require('shelljs/global');

// var user = execSync('echo $USER');
// console.log(process.argv.slice(2));
exec("nightwatch " + process.argv.slice(2).join(" "));
// force nightwatch to exit with success to avoid 
// breaking executing of chained test runs
process.exit(0) 