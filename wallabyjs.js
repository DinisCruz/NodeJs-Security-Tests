module.exports = function () {
    return {
        files: [
            'src/**/*.coffee'
        ],

        tests: [
            //'test/**/*.coffee'
            'test/Test-Array-Slice.coffee'
        ],

        env: {
            type: 'node',
        },
    };
};