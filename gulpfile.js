var gulp = require('gulp');

var coffee = require('gulp-coffee');
var clean = require('gulp-clean');
var insert = require('gulp-insert');

var paths = {
  coffee: ['preresolve.coffee'],
};

gulp.task('coffee', function () {
  return gulp.src(paths.coffee)
    .pipe(coffee())
    .pipe(insert.prepend("#!/usr/bin/env node\n"))
    .pipe(gulp.dest('.'))
    ;
});

gulp.task('clean', function () {
  return gulp.src("preresolve.js", {read: false})
    .pipe(clean({force: true}))
    .pipe(gulp.dest('.'))
    ;
});

// Rerun the task when a file changes
gulp.task('watch', function () {
  gulp.watch(paths.coffee, ['coffee']);
});

gulp.task('build', ['coffee']);

// The default task (called when you run `gulp` from cli)
gulp.task('default', ['build', 'watch']);
