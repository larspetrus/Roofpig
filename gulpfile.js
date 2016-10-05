var gulp   = require('gulp');
var gutil  = require('gulp-util');
var coffee = require('gulp-coffee');
var concat = require('gulp-concat');
var cofcon = require('gulp-coffeescript-concat');
var uglify = require('gulp-uglify');


var rp_coffee_file = 'zz_roofpig.coffee';
var rp_js_file = 'zz_roofpig.js';
var extras_file = 'zz_3extras.js';
var release_file = 'zz_roofpig_and_three.min.js';
var libs = "./rails_project/app/assets/javascripts/";

gulp.task('build-rp', function() {
  return gulp.src('./src/**/*.coffee')
    .pipe(cofcon(rp_coffee_file))
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(uglify())
    .pipe(gulp.dest('.'));
});

gulp.task('build-3extras', function() {
  return gulp.src([libs+'Projector.js', libs+'CanvasRenderer.js'])
    .pipe(uglify())
    .pipe(concat(extras_file))
    .pipe(gulp.dest('.'));
});

gulp.task('build', ['build-rp', 'build-3extras'], function() {
  gulp.src([libs+'three.min.js', extras_file, rp_js_file])
    .pipe(concat(release_file))
    .pipe(gulp.dest('.'));
});
