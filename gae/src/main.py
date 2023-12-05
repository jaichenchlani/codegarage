from flask import Flask, render_template, url_for, jsonify, request, redirect

# If `entrypoint` is not defined in app.yaml, App Engine will look for an app
# called `app` in `main.py`.

print("Entering main.py...")

app = Flask(__name__, template_folder='templates')

@app.route('/')
def render_index_template():
    print("Entering render_index_template...")
    return render_template('index.html')

if __name__ == "__main__":
    # This is used when running locally only. When deploying to Google App
    # Engine, a webserver process such as Gunicorn will serve the app. This
    # can be configured by adding an `entrypoint` to app.yaml.
    
    app.run(host="0.0.0.0", port=8080, debug=True)
