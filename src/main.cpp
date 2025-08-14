#include <boost/accumulators/accumulators.hpp>
#include <boost/accumulators/statistics/mean.hpp>
#include <boost/accumulators/statistics/variance.hpp>
#include <boost/accumulators/statistics/stats.hpp>
#include <iostream>
#include <vector>
#include <cmath>

namespace acc = boost::accumulators;

int main() {
    // Инициализируем аккумулятор для среднего и дисперсии
    acc::accumulator_set<double, acc::stats<acc::tag::mean, acc::tag::variance>> stats;

    // Пример данных
    std::vector<double> data = {1.0, 2.0, 3.0, 4.0, 5.0};

    // Добавляем значения в аккумулятор
    for (double x : data) {
        stats(x);
    }

    // Выводим результаты
    std::cout << "Среднее: " << acc::mean(stats) << "\n";
    std::cout << "Дисперсия: " << acc::variance(stats) << "\n";
    std::cout << "Стандартное отклонение: " << std::sqrt(acc::variance(stats)) << "\n";

    return 0;
}
