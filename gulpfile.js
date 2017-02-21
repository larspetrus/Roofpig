'use strict';

var gulp   = require('gulp');
var gutil  = require('gulp-util');
var coffee = require('gulp-coffee');
var concat = require('gulp-concat');
var cofcon = require('gulp-coffeescript-concat');
var uglify = require('gulp-uglify');

var dateFormat = require('dateformat');
var del        = require('del');
var filenames  = require('gulp-filenames');
var replace    = require('gulp-replace');


var build_dir = 'local/build/';
var rp_js_file = 'roofpig.js';
var extras_file = '3extras.js';
var release_file = 'roofpig_and_three.min.js';

// ------------- BUILD -----

gulp.task('clean-build', function() {
  return del(build_dir +'**/*');
});

gulp.task('build-rp', ['clean-build'], function() {
  return gulp.src('src/**/*.coffee')
    .pipe(cofcon('roofpig.coffee'))
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(replace('@@BUILT_WHEN@@', dateFormat(new Date(), "yyyy-mm-dd HH:MM")))
    .pipe(uglify())
    .pipe(gulp.dest(build_dir));
});

gulp.task('build-3x', ['clean-build'], function() {
  return gulp.src(['lib/Projector.js', 'lib/CanvasRenderer.js'])
    .pipe(uglify())
    .pipe(concat(extras_file))
    .pipe(gulp.dest(build_dir));
});

gulp.task('build', ['build-rp', 'build-3x'], function() {
  gulp.src(['lib/three.min.js', build_dir + extras_file, build_dir + rp_js_file])
    .pipe(concat(release_file))
    .pipe(gulp.dest(build_dir));
});


// ------------- TEST -----

var rename = require("gulp-rename");
var glob   = require("glob");
//var sourcemaps = require('gulp-sourcemaps');

var js_dir = 'local/test_js/';
var test_js_dir = js_dir+'test/';

gulp.task('clean-js', function() {
  return del(js_dir+'**/*');
});

gulp.task('compile-test', ['clean-js'], function() {
  return gulp.src('test/**/*.coffee')
//    .pipe(sourcemaps.init())
    .pipe(coffee({bare: true}).on('error', gutil.log))
//    .pipe(sourcemaps.write())
    .pipe(gulp.dest(test_js_dir));
});

gulp.task('compile-src', ['clean-js'], function() {
  return gulp.src('src/**/*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest(js_dir+'src'));
});

gulp.task('test', ['compile-test', 'compile-src'], function(){
  var test_html = '';
  glob.sync(test_js_dir+'**/*.js', {}).forEach(function(test_file){
    test_html += '<script src="'+test_file+'"></script>\n';
  });

  console.log("\nTests generated. `open rptest.html` can run them!\n")

  return gulp.src('misc/rptest_template.html')
    .pipe(replace('@@TEST_FILES_GO_HERE@@', test_html))
    .pipe(rename('rptest.html'))
    .pipe(gulp.dest('.'));
});
