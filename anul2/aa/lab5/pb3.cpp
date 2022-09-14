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

  vector < int > li, ls;
  li.assign(stk.begin(), stk.end());

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

  ls.assign(stk.rbegin(), stk.rbegin() + stk.size() - min_size + 1);

  Point q;
  cin >> q.x >> q.y;

  if (q.x < v[li[0]].x || q.x > v[li.back()].x) {
    cout << "exterior\n";
    return -1;
  }

  cerr << '\n';

  int st = 0, dr = sz(li) - 2, sol = -1;
  while (st <= dr) {
    int mid = (st + dr) / 2;
    if (v[li[mid]].x <= q.x) {
      sol = mid;
      st = mid + 1;
    }
    else {
      dr = mid - 1;
    }
  }

  int poz_lower = det(v[li[sol]], v[li[sol + 1]], q);

  st = 0; dr = sz(ls) - 2; sol = -1;
  while (st <= dr) {
    int mid = (st + dr) / 2;
    if (v[li[mid]].x <= q.x) {
      sol = mid;
      st = mid + 1;
    }
    else {
      dr = mid - 1;
    }
  }

  int poz_higher = det(v[ls[sol + 1]], v[ls[sol]], q);

  if (poz_higher == 1 && poz_lower == 1) {
    cout << "interior\n";
  }
  else if (poz_higher == 0 || poz_lower == 0) {
    cout << "pe margine\n";
  }
  else {
    cout << "exterior\n";
  }

}
