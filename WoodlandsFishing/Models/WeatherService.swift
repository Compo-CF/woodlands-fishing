import Foundation

/// Fetches current weather conditions for a spot's coordinate from
/// Open-Meteo (free, no API key, unlimited use). Air temp, wind, and
/// conditions are the angler-relevant fields. Water temperature isn't
/// reliably available for small Texas lakes through any free API, so
/// we surface only what we can stand behind.
enum WeatherService {
    struct Snapshot: Hashable {
        let temperatureF: Double
        let weatherCode: Int
        let windMph: Double
        let windDirectionDegrees: Int
    }

    enum WeatherError: Error { case badResponse, decodeFailed }

    /// Fetches a fresh snapshot for the coordinate. Caller is expected to
    /// debounce — typically called once per spot detail view appearance.
    static func fetch(latitude: Double, longitude: Double) async throws -> Snapshot {
        var components = URLComponents(string: "https://api.open-meteo.com/v1/forecast")!
        components.queryItems = [
            .init(name: "latitude", value: String(latitude)),
            .init(name: "longitude", value: String(longitude)),
            .init(name: "current", value: "temperature_2m,weather_code,wind_speed_10m,wind_direction_10m"),
            .init(name: "temperature_unit", value: "fahrenheit"),
            .init(name: "wind_speed_unit", value: "mph"),
            .init(name: "timezone", value: "auto"),
        ]
        var request = URLRequest(url: components.url!)
        request.timeoutInterval = 8
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw WeatherError.badResponse
        }
        struct Response: Decodable {
            struct Current: Decodable {
                let temperature_2m: Double
                let weather_code: Int
                let wind_speed_10m: Double
                let wind_direction_10m: Int
            }
            let current: Current
        }
        guard let decoded = try? JSONDecoder().decode(Response.self, from: data) else {
            throw WeatherError.decodeFailed
        }
        return Snapshot(
            temperatureF: decoded.current.temperature_2m,
            weatherCode: decoded.current.weather_code,
            windMph: decoded.current.wind_speed_10m,
            windDirectionDegrees: decoded.current.wind_direction_10m
        )
    }
}

extension WeatherService.Snapshot {
    /// Open-Meteo WMO weather code → short human label.
    var conditionLabel: String {
        switch weatherCode {
        case 0: "Clear"
        case 1: "Mainly clear"
        case 2: "Partly cloudy"
        case 3: "Overcast"
        case 45, 48: "Fog"
        case 51, 53, 55: "Drizzle"
        case 56, 57: "Freezing drizzle"
        case 61, 63, 65: "Rain"
        case 66, 67: "Freezing rain"
        case 71, 73, 75, 77: "Snow"
        case 80, 81, 82: "Showers"
        case 85, 86: "Snow showers"
        case 95: "Thunderstorm"
        case 96, 99: "Thunderstorm with hail"
        default: "—"
        }
    }

    /// Open-Meteo WMO weather code → SF Symbol.
    var conditionSymbol: String {
        switch weatherCode {
        case 0: "sun.max.fill"
        case 1, 2: "cloud.sun.fill"
        case 3: "cloud.fill"
        case 45, 48: "cloud.fog.fill"
        case 51, 53, 55, 80, 81, 82: "cloud.drizzle.fill"
        case 56, 57, 66, 67: "cloud.sleet.fill"
        case 61, 63, 65: "cloud.rain.fill"
        case 71, 73, 75, 77, 85, 86: "cloud.snow.fill"
        case 95, 96, 99: "cloud.bolt.rain.fill"
        default: "cloud.fill"
        }
    }

    /// Wind direction degrees → cardinal (N, NE, E, SE, S, SW, W, NW).
    var windCardinal: String {
        let dirs = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        let index = Int((Double(windDirectionDegrees) + 22.5) / 45.0) % 8
        return dirs[index]
    }

    /// Short one-line summary suitable for a compact weather row.
    var summary: String {
        let temp = Int(temperatureF.rounded())
        let wind = Int(windMph.rounded())
        return "\(temp)°F · \(conditionLabel) · Wind \(wind) mph \(windCardinal)"
    }
}
