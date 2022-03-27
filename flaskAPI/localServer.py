from flask import Flask, request
# 作成した関数を外部ソースからimport
from functions.recommend import recommend_function
from functions.stroll import stroll_function

app = Flask(__name__)

# methodにPOST等も明示的に指定(FlaskではデフォルトGETのみのため)
# '/~'がテストするときのパス


@app.route('/recommend', methods=['GET', 'POST'])
def recommend_api():
    return recommend_function(request)


@app.route('/stroll', methods=['GET', 'POST'])
def stroll_api():
    return stroll_function(request)


if __name__ == '__main__':
    app.run()