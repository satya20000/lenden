from pathlib import Path
import argparse
from lending import lending
if __name__=='__main__':
    parser=argparse.ArgumentParser(description='LendingClub Credit Portfolio')
    parser.add_argument('--root',type=Path,default=Path(__file__).resolve().parents[1])
    args=parser.parse_args()
    c=lending(args.root)
    print('\n'.join(c.findings))
