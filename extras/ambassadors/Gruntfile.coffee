module.exports = (grunt) ->

  # configuration
  grunt.initConfig

    # grunt sass
    sass:
      compile:
        options:
          style: 'expanded'
        files: [
          expand: true
          cwd: 'src/sass'
          src: ['**/*.scss']
          dest: 'src/css'
          ext: '.css'
        ]

    # grunt coffee
    coffee:
      compile:
        expand: true
        cwd: 'src/coffee'
        src: ['**/*.coffee']
        dest: 'src/js'
        ext: '.js'
        options:
          bare: true
          preserve_dirs: true

    # grunt concat
    concat:
      options: 
        separator: ';'
      dist:
        src: ['src/js/bootstrap-tooltip.js', 'src/js/qm-ambassadors.js']
        dest: 'dist/js/qm-ambassadors.js'



    # grunt jshint
    jshint:
      files: ['src/js/*.js']
      options:
        curly: true
        eqeqeq: false
        eqnull: true
        browser: true
        globals:
          $: true
          jQuery: true

    # grunt uglify
    uglify:
      dist:
        files:
          'dist/js/qm-ambassadors.min.js': ['dist/js/qm-ambassadors.js']

    # grunt cssmin
    cssmin:
      dist:
        files:
          'dist/css/qm-ambassadors.min.css': ['src/css/**/*.css']

    # grunt connect
    connect:
      uses_defaults: {}

    # grunt watch (or simply grunt)
    watch:
      sass:
        files: '<%= sass.compile.files[0].src %>'
        tasks: ['sass']
      coffee:
        files: '<%= coffee.compile.src %>'
        tasks: ['coffee']
      #jshint:
      #  files: '<%= jshint.files %>'
      #  tasks: ['jshint']
      options:
        livereload: true


  # load plugins
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'

  # tasks
  grunt.registerTask 'default', ['sass', 'coffee', 'connect', 'watch']
  grunt.registerTask 'deploy', ['sass', 'coffee', 'concat', 'uglify', 'cssmin']
