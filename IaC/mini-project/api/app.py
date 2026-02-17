# simple JSON REST API talking to Postgres
from flask import Flask, request, jsonify, abort
import os
import psycopg2
from psycopg2.extras import RealDictCursor

DB_HOST = os.getenv("DB_HOST", "postgres")
DB_PORT = int(os.getenv("DB_PORT", 5432))
DB_NAME = os.getenv("DB_NAME", "exampledb")
DB_USER = os.getenv("DB_USER", "example")
DB_PASS = os.getenv("DB_PASS", "examplepass")

def get_conn():
    return psycopg2.connect(
        host=DB_HOST, port=DB_PORT, dbname=DB_NAME, user=DB_USER, password=DB_PASS
    )

app = Flask(__name__)

@app.route("/")
def hello():
    return jsonify({"status":"ok","msg":"Mini Project API"})

@app.route("/items", methods=["GET"])
def list_items():
    with get_conn() as conn:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("SELECT id, name, description FROM items ORDER BY id")
            rows = cur.fetchall()
            return jsonify(rows)

@app.route("/items/<int:item_id>", methods=["GET"])
def get_item(item_id):
    with get_conn() as conn:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("SELECT id, name, description FROM items WHERE id=%s", (item_id,))
            row = cur.fetchone()
            if not row:
                abort(404)
            return jsonify(row)

@app.route("/items", methods=["POST"])
def create_item():
    data = request.get_json(force=True)
    name = data.get("name")
    description = data.get("description","")
    if not name:
        return jsonify({"error":"name required"}), 400
    with get_conn() as conn:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("INSERT INTO items (name, description) VALUES (%s,%s) RETURNING id, name, description",
                        (name, description))
            row = cur.fetchone()
            conn.commit()
            return jsonify(row), 201

@app.route("/items/<int:item_id>", methods=["DELETE"])
def delete_item(item_id):
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("DELETE FROM items WHERE id=%s RETURNING id", (item_id,))
            row = cur.fetchone()
            if not row:
                abort(404)
            conn.commit()
            return "", 204

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)