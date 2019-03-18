import sys
from tdl.queue.queue_based_implementation_runner import QueueBasedImplementationRunnerBuilder
from tdl.runner.challenge_session import ChallengeSession
from solutions.SUM import sum_solution
from solutions.HLO import hello_solution
from solutions.FIZ import fizz_buzz_solution
from solutions.CHK import checkout_solution
from runner.utils import Utils
from runner.user_input_action import get_user_input


"""
  ~~~~~~~~~~ Running the system: ~~~~~~~~~~~~~
 
    From IDE:
       Run this file from the IDE.
 
    From command line:
       PYTHONPATH=lib python lib/send_command_to_server.py
 
    To run your unit tests locally:
       PYTHONPATH=lib python -m pytest -q test/solution_tests/
 
  ~~~~~~~~~~ The workflow ~~~~~~~~~~~~~
 
    By running this file you interact with a challenge server.
    The interaction follows a request-response pattern:
         * You are presented with your current progress and a list of actions.
         * You trigger one of the actions by typing it on the console.
         * After the action feedback is presented, the execution will stop.
 
    +------+-------------------------------------------------------------+
    | Step | The usual workflow                                          |
    +------+-------------------------------------------------------------+
    |  1.  | Run this file.                                              |
    |  2.  | Start a challenge by typing "start".                        |
    |  3.  | Read description from the "challenges" folder               |
    |  4.  | Implement the required method in                            |
    |      |   ./lib/solutions                                           |
    |  5.  | Deploy to production by typing "deploy".                    |
    |  6.  | Observe output, check for failed requests.                  |
    |  7.  | If passed, go to step 3.                                    |
    +------+-------------------------------------------------------------+
 
    You are encouraged to change this project as you please:
         * You can use your preferred libraries.
         * You can use your own test framework.
         * You can change the file structure.
         * Anything really, provided that this file stays runnable.
 
"""

runner = QueueBasedImplementationRunnerBuilder()\
    .set_config(Utils.get_runner_config())\
    .with_solution_for('sum', sum_solution.compute)\
    .with_solution_for('hello', hello_solution.hello)\
    .with_solution_for('fizz_buzz', fizz_buzz_solution.fizz_buzz)\
    .with_solution_for('checkout', checkout_solution.checkout)\
    .create()

ChallengeSession\
    .for_runner(runner)\
    .with_config(Utils.get_config())\
    .with_action_provider(lambda: get_user_input(sys.argv[1:]))\
    .start()
