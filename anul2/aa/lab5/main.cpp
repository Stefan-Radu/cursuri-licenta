
// By Stefan Radu

#include <bits/stdc++.h>

using namespace std;

#define sz(x) (int)(x).size()

struct Point {
  long double x, y;
};

struct Triplet {
  int i, j, r;
};

const long double EPS = 1e-12;
const long double INF = 1e18;

int det(const Point &a, const Point &b, const Point &c) {
  long double det = a.x * b.y + b.x * c.y + c.x * a.y -
    a.y * b.x - b.y * c.x - c.y * a.x;

  if (abs(det) < EPS) return 0;
  if (det < 0) return -1;
  return 1;
}

long double sq(long double k) { return k * k; }

long double get_dist(const Point &a, const Point &b) {
  return sqrt(sq(a.x - b.x) + sq(a.y - b.y));
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

  set < int > not_inserted;
  for (int i = 0; i < n; ++ i) {
    if (!used[i]) {
      not_inserted.insert(i);
    }
  }

  vector < int > hull;
  while (!stk.empty()) {
    if (used[stk.back()]) {
      hull.push_back(stk.back());
      used[stk.back()] = false;
    }
    stk.pop_back();
  }
  hull.push_back(hull[0]);

  while (not_inserted.size()) {
    vector < Triplet > aux;
    for (auto &r : not_inserted) {
      Triplet t;
      long double min_val = INF;
      for (int i = 0; i < sz(hull) - 2; ++ i) {
        long double dist = get_dist(v[hull[i]], v[r]) + get_dist(v[hull[i + 1]], v[r]) 
          - get_dist(v[hull[i]], v[hull[i + 1]]);
        if (dist < min_val) {
          min_val = dist;
          t = {i, i + 1, r};
        }
      }

      aux.push_back(t);
    }

    Triplet the_t;
    long double min_val = INF;
    for (auto &t : aux) {
      long double val = (get_dist(v[hull[t.i]], v[t.r]) + get_dist(v[hull[t.j]], v[t.r])) /
        get_dist(v[hull[t.i]], v[hull[t.j]]);
      if (val < min_val) {
        the_t = t;
      }
    }

    not_inserted.erase(the_t.r);
    hull.insert(hull.begin() + the_t.j, the_t.r);
  }

  for (auto &x : hull) {
    cout << x + 1 << ' ';
  }
  cout << '\n';
}
