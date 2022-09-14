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

long double sq(long double k) { return k * k; }

long double get_sq_dist(const Point &a, const Point &b) {
  return sq(a.x - b.x) + sq(a.y - b.y);
}

int main() {

  int n; cin >> n;
  vector < Point > v(n);
  for (int i = 0; i < n; ++ i) {
    cin >> v[i].x >> v[i].y;
  }

  vector < int > stk;
  if (n < 2) {
    cout << "naspa\n";
    return -1;
  }

  stk.push_back(0);
  stk.push_back(1);

  vector < bool > used(n);
  used[1] = true;

  for (int i = 2; i < n; ++ i) {
    while (sz(stk) > 2 && 
        det(v[stk[sz(stk) - 2]], v[stk[sz(stk) - 1]], v[i]) == -1) {
      used[stk.back()] = false;
      stk.pop_back();
    }
    stk.push_back(i);
    used[i] = true;
  }

  int min_size = sz(stk);

  for (int i = n - 2; i >= 0; -- i) {
    if (used[i]) continue;

    while (sz(stk) > min_size && 
        det(v[stk[sz(stk) - 2]], v[stk[sz(stk) - 1]], v[i]) == -1) {
      used[stk.back()] = false;
      stk.pop_back();
    }
    stk.push_back(i);
    used[i] = true;
  }

  vector < int > hull;
  while (!stk.empty()) {
    if (used[stk.back()]) {
      cout << v[stk.back()].x << ' ' << v[stk.back()].y << '\n';
      used[stk.back()] = false;
    }
    stk.pop_back();
  }
}
