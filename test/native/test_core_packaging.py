"""Run with python3 -m unittest discover -s test/native -v."""
import pathlib
import shutil
import subprocess
import tempfile
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[2]
VERIFY = ROOT / 'android/core/src/main/cpp/verify_core.cmake'


class CorePackagingTest(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.path = pathlib.Path(self.directory.name)
        self.library = self.path / 'libclash.so'
        self.script = self.path / 'check.cmake'
        self.script.write_text(
            f'include("{VERIFY}")\nverify_clash_core("{self.library}")\n'
        )

    def build(self, symbols):
        source = self.path / 'core.c'
        source.write_text('\n'.join(f'void {name}(void) {{}}' for name in symbols))
        subprocess.run(['cc', '-shared', '-fPIC', str(source), '-o', str(self.library)],
                       check=True, capture_output=True)

    def check_core(self):
        return subprocess.run(['cmake', f'-DCMAKE_NM={shutil.which("nm")}',
                               '-P', str(self.script)], capture_output=True, text=True)

    def test_current_callback_exports(self):
        self.build(['registerCallbacks', 'setEventListener', 'invokeAction',
                    'quickStart', 'resetConnections'])
        result = self.check_core()
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_legacy_dart_port_core_is_rejected(self):
        self.build(['registerCallbacks', 'invokeAction', 'quickStart', 'attachMessagePort'])
        result = self.check_core()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('missing setEventListener', ' '.join(result.stderr.split()))

    def test_missing_core_is_rejected(self):
        result = self.check_core()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('Missing Android core', result.stderr)

    def test_corrupt_core_is_rejected(self):
        self.library.write_bytes(b'not a shared library')
        result = self.check_core()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('Cannot inspect Android core', result.stderr)
