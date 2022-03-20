from flask import Flask, request
# 作成した関数を外部ソースからimport
from functions.recommend import recommend_function

app = Flask(__name__)

# methodにPOST等も明示的に指定(FlaskではデフォルトGETのみのため)
# '/~'がテストするときのパス


@app.route('/recommend', methods=['GET', 'POST'])
def local_api():
    return recommend_function(request)


if __name__ == '__main__':
    app.run()