import sys


if sys.platform == 'win32':
    __switches__ = {
        'import' : [
            'nimble',
            'c',
            '--accept',
            '--app:lib',
            '-d:release',
            '--opt:speed',
            '-d:ssl',
            '--cc:vcc',
            f'--out:{BUILD_ARTIFACT}',
            f'{MODULE_PATH}'
        ],
        'bundle' : [
            'nimble' if IS_LIBRARY else 'nim',
            'cc',
            '-c',
            '--accept',
            f'--nimcache:{BUILD_DIR}',
            f'{MODULE_PATH}'
        ]
    }

else:
    __switches__ = {
        'import' : [
            'nimble',
            'c',
            '--accept',
            '--app:lib',
            '-d:release',
            '--opt:speed',
            '-d:ssl',
            f'--out:{BUILD_ARTIFACT}',
            f'{MODULE_PATH}'
        ],
        'bundle' : [
            'nimble' if IS_LIBRARY else 'nim',
            'cc',
            '-c',
            '--accept',
            f'--nimcache:{BUILD_DIR}',
            f'{MODULE_PATH}'
        ]
    }
