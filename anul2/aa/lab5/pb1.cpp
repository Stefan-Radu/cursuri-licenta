// By Stefan Radu

#include <bits/stdc++.h>

using namespace std;

#define sz(x) (int)(x).size()

struct Point {
  long double x, y;
};

const long double EPS = 1e-12;

int det(const Point &a, const Point &b, const Point &c) {
  long double det = a.x * b.y + b.x * c.y + c.x * a.y -
    a.y * b.x - b.y * c.x - c.y * a.x;

  if (abs(det) < EPS) return 0;
  if (det < 0) return -1;
  return 1;
}

string get_direction(const Point &a, const Point &b, const Point &c) {
  int d = det(a, b, c);
  if (d == -1) return "spre dreapta\n";
  if (d == 1) return "spre stanga\n";
  return "coliniare\n";
}

int main() {

  Point a, b, c;
  cin >> a.x >> a.y;
  cin >> b.x >> b.y;
  cin >> c.x >> c.y;

  cout << get_direction(a, b, c);
}
