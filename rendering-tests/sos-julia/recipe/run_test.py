# import unittest
# import sys
# import time

# from sos_notebook.test_utils import sos_kernel
# from ipykernel.tests.utils import execute, wait_for_idle, assemble_output

# class TestSoSKernel(unittest.TestCase):
    # def testKernel(self):
        # with sos_kernel() as kc:
            # execute(kc=kc, code='a = 1')
            # stdout, stderr = assemble_output(kc.get_iopub_msg)
            # self.assertEqual(stdout.strip(), '', f'Stdout is not empty, "{stdout}" received')
            # self.assertEqual(stderr.strip(), '', f'Stderr is not empty, "{stderr}" received')
            # #time.sleep(30)
            # #execute(kc=kc, code='%use Julia\n%get a\nprint(a)')
            # #time.sleep(10)
            # #stdout, stderr = assemble_output(kc.get_iopub_msg)
            # #self.assertEqual(stderr.strip(), '', f'Stderr is not empty, "{stderr}" received')
            # #self.assertEqual(stdout.splitlines()[-1].strip(), '1', f'Stdout should be 1, "{stdout}" received')

# if __name__ == '__main__':
    # unittest.main()
