'use strict';

var gulp   = require('gulp');
var gutil  = require('gulp-util');
var coffee = require('gulp-coffee');
var concat = require('gulp-concat');
var cofcon = require('gulp-coffeescript-concat');
var uglify = require('gulp-uglify');

var dateFormat = require('dateformat');
var del        = require('del');
var replace    = require('gulp-replace');


// ------------- BUILD -----

var build_dir = 'local/build/';
var roofpig_file = 'roofpig.js';
var extras_file = '3extras.js';
var release_file = 'roofpig_and_three.min.js';

function cleanBuild() {
  return del(build_dir +'**/*');
}

function roofpig() {
  return gulp.src('src/**/*.coffee')
    .pipe(cofcon('roofpig.coffee'))
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(replace('@@BUILT_WHEN@@', dateFormat(new Date(), "yyyy-mm-dd HH:MM")))
    .pipe(uglify())
    .pipe(gulp.dest(build_dir));
}

function extras() {
  return gulp.src(['lib/Projector.js', 'lib/CanvasRenderer.js'])
    .pipe(uglify())
    .pipe(concat(extras_file))
    .pipe(gulp.dest(build_dir));  
}

async function createDemo() {
  return gulp.src('demo.html')
    .pipe(replace('Official release version', 'Local build version'))
    .pipe(replace('src="lib/jquery-3.1.1.min.js"', 'src="../../lib/jquery-3.1.1.min.js"'))
    .pipe(rename('local_demo.html'))
    .pipe(gulp.dest(build_dir));
}

async function combine() {
  return gulp.src(['lib/three.min.js', build_dir + extras_file, build_dir + roofpig_file])
    .pipe(concat(release_file))
    .pipe(gulp.dest(build_dir));
}

exports.default = exports.build = gulp.series(cleanBuild, gulp.parallel(roofpig, extras, createDemo), combine);


// ------------- TEST -----

var rename = require("gulp-rename");
var glob   = require("glob");
//var sourcemaps = require('gulp-sourcemaps');

var test_dir = 'local/test/';
var rel_source_dir = 'src/';
var source_dir = test_dir + rel_source_dir;
var rel_spec_dir = 'specs/';
var spec_dir = test_dir + rel_spec_dir;

function cleanTest() {
  return del(test_dir + '**/*');
}

function compileSpecs() {
  return gulp.src('test/**/*.coffee')
//    .pipe(sourcemaps.init())
    .pipe(coffee({bare: true}).on('error', gutil.log))
//    .pipe(sourcemaps.write())
    .pipe(gulp.dest(spec_dir));
}

function compileTestSource() {
  return gulp.src('src/**/*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest(source_dir));
}

function renderMochaTemplate() {
  var test_html = '';
  glob.sync('**/*.js', {cwd: spec_dir}).forEach(function(test_file) {
    test_html += '<script src="' + rel_spec_dir + test_file + '"></script>\n';
  });

  console.log("\nTests generated. `open local/test/mocha.html` can run them!\n")

  return gulp.src('test/mocha.html')
    .pipe(replace('@@TEST_FILES_GO_HERE@@', test_html))
    .pipe(rename('mocha.html'))
    .pipe(gulp.dest(test_dir));
}

exports.test = gulp.series(cleanTest, gulp.parallel(compileSpecs, compileTestSource), renderMochaTemplate);
