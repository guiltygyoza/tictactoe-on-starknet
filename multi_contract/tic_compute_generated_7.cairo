%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.storage import Storage
from starkware.cairo.common.math_cmp import is_not_zero

### THIS CONTRACT IS GENERATED BY GUILTYGYOZA'S SCRIPT ###

func is_zero {range_check_ptr} (value) -> (res):
    # invert the result of is_not_zero()
    let (temp) = is_not_zero(value)
    if temp == 0:
        return (res=1)
    end

    return (res=0)
end

@view
func compute{
        syscall_ptr : felt*,
        storage_ptr : Storage*,
        range_check_ptr
    }(
        a : felt,
        s : felt
    ) -> (
        result : felt
    ):
    alloc_locals

    let (local bool_1974) = is_zero( (a-5) + (s-74450) )
    let (local bool_1975) = is_zero( (a-5) + (s-140160) )
    let (local bool_1976) = is_zero( (a-5) + (s-67020) )
    let (local bool_1977) = is_zero( (a-5) + (s-74330) )
    let (local bool_1978) = is_zero( (a-5) + (s-111240) )
    let (local bool_1979) = is_zero( (a-5) + (s-60300) )
    let (local bool_1980) = is_zero( (a-5) + (s-67440) )
    let (local bool_1981) = is_zero( (a-5) + (s-36450) )
    let (local bool_1982) = is_zero( (a-5) + (s-1050) )
    let (local bool_1983) = is_zero( (a-5) + (s-210) )
    let (local bool_1984) = is_zero( (a-5) + (s-24180) )
    let (local bool_1985) = is_zero( (a-5) + (s-74690) )
    let (local bool_1986) = is_zero( (a-5) + (s-52920) )
    let (local bool_1987) = is_zero( (a-5) + (s-15150) )
    let (local bool_1988) = is_zero( (a-5) + (s-37280) )
    let (local bool_1989) = is_zero( (a-5) + (s-58350) )
    let (local bool_1990) = is_zero( (a-5) + (s-81920) )
    let (local bool_1991) = is_zero( (a-5) + (s-125590) )
    let (local bool_1992) = is_zero( (a-5) + (s-51210) )
    let (local bool_1993) = is_zero( (a-5) + (s-43900) )
    let (local bool_1994) = is_zero( (a-5) + (s-131490) )
    let (local bool_1995) = is_zero( (a-5) + (s-82390) )
    let (local bool_1996) = is_zero( (a-5) + (s-760) )
    let (local bool_1997) = is_zero( (a-5) + (s-24250) )
    let (local bool_1998) = is_zero( (a-5) + (s-38140) )
    let (local bool_1999) = is_zero( (a-5) + (s-8840) )
    let (local bool_2000) = is_zero( (a-5) + (s-132880) )
    let (local bool_2001) = is_zero( (a-6) + (s-0) )
    let (local bool_2002) = is_zero( (a-6) + (s-830) )
    let (local bool_2003) = is_zero( (a-6) + (s-1620) )
    let (local bool_2004) = is_zero( (a-6) + (s-23510) )
    let (local bool_2005) = is_zero( (a-6) + (s-67230) )
    let (local bool_2006) = is_zero( (a-6) + (s-72180) )
    let (local bool_2007) = is_zero( (a-6) + (s-4070) )
    let (local bool_2008) = is_zero( (a-6) + (s-1890) )
    let (local bool_2009) = is_zero( (a-6) + (s-67520) )
    let (local bool_2010) = is_zero( (a-6) + (s-1910) )
    let (local bool_2011) = is_zero( (a-6) + (s-4860) )
    let (local bool_2012) = is_zero( (a-6) + (s-28350) )
    let (local bool_2013) = is_zero( (a-6) + (s-67280) )
    let (local bool_2014) = is_zero( (a-6) + (s-6490) )
    let (local bool_2015) = is_zero( (a-6) + (s-2490) )
    let (local bool_2016) = is_zero( (a-6) + (s-155580) )
    let (local bool_2017) = is_zero( (a-6) + (s-157470) )
    let (local bool_2018) = is_zero( (a-6) + (s-1670) )
    let (local bool_2019) = is_zero( (a-6) + (s-67250) )
    let (local bool_2020) = is_zero( (a-6) + (s-1710) )
    let (local bool_2021) = is_zero( (a-6) + (s-1780) )
    let (local bool_2022) = is_zero( (a-6) + (s-132850) )
    let (local bool_2023) = is_zero( (a-6) + (s-111060) )
    let (local bool_2024) = is_zero( (a-6) + (s-1650) )
    let (local bool_2025) = is_zero( (a-6) + (s-23540) )
    let (local bool_2026) = is_zero( (a-6) + (s-26510) )
    let (local bool_2027) = is_zero( (a-6) + (s-3800) )
    let (local bool_2028) = is_zero( (a-6) + (s-135050) )
    let (local bool_2029) = is_zero( (a-6) + (s-72200) )
    let (local bool_2030) = is_zero( (a-6) + (s-133000) )
    let (local bool_2031) = is_zero( (a-6) + (s-1760) )
    let (local bool_2032) = is_zero( (a-6) + (s-4050) )
    let (local bool_2033) = is_zero( (a-6) + (s-135360) )
    let (local bool_2034) = is_zero( (a-6) + (s-135430) )
    let (local bool_2035) = is_zero( (a-6) + (s-70130) )
    let (local bool_2036) = is_zero( (a-6) + (s-6800) )
    let (local bool_2037) = is_zero( (a-6) + (s-23490) )
    let (local bool_2038) = is_zero( (a-6) + (s-69860) )
    let (local bool_2039) = is_zero( (a-6) + (s-135970) )
    let (local bool_2040) = is_zero( (a-6) + (s-1630) )
    let (local bool_2041) = is_zero( (a-6) + (s-20) )
    let (local bool_2042) = is_zero( (a-6) + (s-540) )
    let (local bool_2043) = is_zero( (a-6) + (s-67770) )
    let (local bool_2044) = is_zero( (a-6) + (s-154720) )
    let (local bool_2045) = is_zero( (a-6) + (s-72230) )
    let (local bool_2046) = is_zero( (a-6) + (s-133060) )
    let (local bool_2047) = is_zero( (a-6) + (s-109350) )
    let (local bool_2048) = is_zero( (a-6) + (s-110180) )
    let (local bool_2049) = is_zero( (a-6) + (s-154980) )
    let (local bool_2050) = is_zero( (a-6) + (s-4340) )
    let (local bool_2051) = is_zero( (a-6) + (s-60) )
    let (local bool_2052) = is_zero( (a-6) + (s-23550) )
    let (local bool_2053) = is_zero( (a-6) + (s-135280) )
    let (local bool_2054) = is_zero( (a-6) + (s-4260) )
    let (local bool_2055) = is_zero( (a-6) + (s-157140) )
    let (local bool_2056) = is_zero( (a-6) + (s-44600) )
    let (local bool_2057) = is_zero( (a-6) + (s-72090) )
    let (local bool_2058) = is_zero( (a-6) + (s-5960) )
    let (local bool_2059) = is_zero( (a-6) + (s-27890) )
    let (local bool_2060) = is_zero( (a-6) + (s-70470) )
    let (local bool_2061) = is_zero( (a-6) + (s-1940) )
    let (local bool_2062) = is_zero( (a-6) + (s-45450) )
    let (local bool_2063) = is_zero( (a-6) + (s-45500) )
    let (local bool_2064) = is_zero( (a-6) + (s-2120) )
    let (local bool_2065) = is_zero( (a-6) + (s-111020) )
    let (local bool_2066) = is_zero( (a-6) + (s-113630) )
    let (local bool_2067) = is_zero( (a-6) + (s-28440) )
    let (local bool_2068) = is_zero( (a-6) + (s-4950) )
    let (local bool_2069) = is_zero( (a-6) + (s-5020) )
    let (local bool_2070) = is_zero( (a-6) + (s-28510) )
    let (local bool_2071) = is_zero( (a-6) + (s-5130) )
    let (local bool_2072) = is_zero( (a-6) + (s-72360) )
    let (local bool_2073) = is_zero( (a-6) + (s-72410) )
    let (local bool_2074) = is_zero( (a-6) + (s-135340) )
    let (local bool_2075) = is_zero( (a-6) + (s-135490) )
    let (local bool_2076) = is_zero( (a-6) + (s-67290) )
    let (local bool_2077) = is_zero( (a-6) + (s-45630) )
    let (local bool_2078) = is_zero( (a-6) + (s-111960) )
    let (local bool_2079) = is_zero( (a-6) + (s-113610) )
    let (local bool_2080) = is_zero( (a-6) + (s-157690) )
    let (local bool_2081) = is_zero( (a-6) + (s-2190) )
    let (local bool_2082) = is_zero( (a-6) + (s-135840) )
    let (local bool_2083) = is_zero( (a-6) + (s-180) )
    let (local bool_2084) = is_zero( (a-6) + (s-67410) )
    let (local bool_2085) = is_zero( (a-6) + (s-43740) )
    let (local bool_2086) = is_zero( (a-6) + (s-44570) )
    let (local bool_2087) = is_zero( (a-6) + (s-47540) )
    let (local bool_2088) = is_zero( (a-6) + (s-47690) )
    let (local bool_2089) = is_zero( (a-6) + (s-450) )
    let (local bool_2090) = is_zero( (a-6) + (s-6120) )
    let (local bool_2091) = is_zero( (a-6) + (s-28620) )
    let (local bool_2092) = is_zero( (a-6) + (s-6510) )
    let (local bool_2093) = is_zero( (a-6) + (s-45720) )
    let (local bool_2094) = is_zero( (a-6) + (s-45770) )
    let (local bool_2095) = is_zero( (a-6) + (s-116240) )
    let (local bool_2096) = is_zero( (a-6) + (s-1370) )
    let (local bool_2097) = is_zero( (a-6) + (s-72470) )
    let (local bool_2098) = is_zero( (a-6) + (s-69840) )
    let (local bool_2099) = is_zero( (a-6) + (s-131220) )
    let (local bool_2100) = is_zero( (a-6) + (s-154710) )
    let (local bool_2101) = is_zero( (a-6) + (s-70) )
    let (local bool_2102) = is_zero( (a-6) + (s-23560) )
    let (local bool_2103) = is_zero( (a-6) + (s-154870) )
    let (local bool_2104) = is_zero( (a-6) + (s-176620) )
    let (local bool_2105) = is_zero( (a-6) + (s-72380) )
    let (local bool_2106) = is_zero( (a-6) + (s-22760) )
    let (local bool_2107) = is_zero( (a-6) + (s-154780) )
    let (local bool_2108) = is_zero( (a-6) + (s-132870) )
    let (local bool_2109) = is_zero( (a-6) + (s-111260) )
    let (local bool_2110) = is_zero( (a-6) + (s-49730) )
    let (local bool_2111) = is_zero( (a-6) + (s-67400) )
    let (local bool_2112) = is_zero( (a-6) + (s-94130) )
    let (local bool_2113) = is_zero( (a-6) + (s-23640) )
    let (local bool_2114) = is_zero( (a-6) + (s-1840) )
    let (local bool_2115) = is_zero( (a-6) + (s-69890) )
    let (local bool_2116) = is_zero( (a-6) + (s-150) )
    let (local bool_2117) = is_zero( (a-6) + (s-2040) )
    let (local bool_2118) = is_zero( (a-6) + (s-153090) )
    let (local bool_2119) = is_zero( (a-6) + (s-155410) )
    let (local bool_2120) = is_zero( (a-6) + (s-133110) )
    let (local bool_2121) = is_zero( (a-6) + (s-890) )
    let (local bool_2122) = is_zero( (a-6) + (s-159730) )
    let (local bool_2123) = is_zero( (a-6) + (s-5690) )
    let (local bool_2124) = is_zero( (a-6) + (s-2170) )
    let (local bool_2125) = is_zero( (a-6) + (s-132930) )
    let (local bool_2126) = is_zero( (a-6) + (s-113400) )
    let (local bool_2127) = is_zero( (a-6) + (s-2250) )
    let (local bool_2128) = is_zero( (a-6) + (s-2630) )
    let (local bool_2129) = is_zero( (a-6) + (s-24030) )
    let (local bool_2130) = is_zero( (a-6) + (s-1010) )
    let (local bool_2131) = is_zero( (a-6) + (s-1730) )
    let (local bool_2132) = is_zero( (a-6) + (s-133480) )
    let (local bool_2133) = is_zero( (a-6) + (s-6570) )
    let (local bool_2134) = is_zero( (a-6) + (s-69680) )
    let (local bool_2135) = is_zero( (a-6) + (s-65790) )
    let (local bool_2136) = is_zero( (a-6) + (s-135820) )
    let (local bool_2137) = is_zero( (a-6) + (s-110) )
    let (local bool_2138) = is_zero( (a-6) + (s-70580) )
    let (local bool_2139) = is_zero( (a-6) + (s-70610) )
    let (local bool_2140) = is_zero( (a-6) + (s-72500) )
    let (local bool_2141) = is_zero( (a-6) + (s-67880) )
    let (local bool_2142) = is_zero( (a-6) + (s-111650) )
    let (local bool_2143) = is_zero( (a-6) + (s-154800) )
    let (local bool_2144) = is_zero( (a-6) + (s-155370) )
    let (local bool_2145) = is_zero( (a-6) + (s-67730) )
    let (local bool_2146) = is_zero( (a-6) + (s-21890) )
    let (local bool_2147) = is_zero( (a-6) + (s-116190) )
    let (local bool_2148) = is_zero( (a-6) + (s-6750) )
    let (local bool_2149) = is_zero( (a-6) + (s-160000) )
    let (local bool_2150) = is_zero( (a-6) + (s-67700) )
    let (local bool_2151) = is_zero( (a-6) + (s-1830) )
    let (local bool_2152) = is_zero( (a-6) + (s-45390) )
    let (local bool_2153) = is_zero( (a-6) + (s-45580) )
    let (local bool_2154) = is_zero( (a-6) + (s-133650) )
    let (local bool_2155) = is_zero( (a-6) + (s-135540) )
    let (local bool_2156) = is_zero( (a-6) + (s-46170) )
    let (local bool_2157) = is_zero( (a-6) + (s-133120) )
    let (local bool_2158) = is_zero( (a-6) + (s-179020) )
    let (local bool_2159) = is_zero( (a-6) + (s-2970) )
    let (local bool_2160) = is_zero( (a-6) + (s-4600) )
    let (local bool_2161) = is_zero( (a-6) + (s-4810) )
    let (local bool_2162) = is_zero( (a-6) + (s-290) )
    let (local bool_2163) = is_zero( (a-6) + (s-66500) )
    let (local bool_2164) = is_zero( (a-6) + (s-870) )
    let (local bool_2165) = is_zero( (a-6) + (s-3840) )
    let (local bool_2166) = is_zero( (a-6) + (s-135070) )
    let (local bool_2167) = is_zero( (a-6) + (s-47800) )
    let (local bool_2168) = is_zero( (a-6) + (s-48010) )
    let (local bool_2169) = is_zero( (a-6) + (s-1810) )
    let (local bool_2170) = is_zero( (a-6) + (s-4300) )
    let (local bool_2171) = is_zero( (a-6) + (s-110970) )
    let (local bool_2172) = is_zero( (a-6) + (s-43830) )
    let (local bool_2173) = is_zero( (a-6) + (s-1770) )
    let (local bool_2174) = is_zero( (a-6) + (s-23660) )
    let (local bool_2175) = is_zero( (a-6) + (s-46280) )
    let (local bool_2176) = is_zero( (a-6) + (s-48170) )
    let (local bool_2177) = is_zero( (a-6) + (s-135910) )
    let (local bool_2178) = is_zero( (a-6) + (s-153920) )
    let (local bool_2179) = is_zero( (a-6) + (s-4660) )
    let (local bool_2180) = is_zero( (a-6) + (s-4230) )
    let (local bool_2181) = is_zero( (a-6) + (s-135270) )
    let (local bool_2182) = is_zero( (a-6) + (s-27620) )
    let (local bool_2183) = is_zero( (a-6) + (s-48060) )
    let (local bool_2184) = is_zero( (a-6) + (s-67580) )
    let (local bool_2185) = is_zero( (a-6) + (s-4110) )
    let (local bool_2186) = is_zero( (a-6) + (s-2070) )
    let (local bool_2187) = is_zero( (a-6) + (s-1950) )
    let (local bool_2188) = is_zero( (a-6) + (s-159580) )
    let (local bool_2189) = is_zero( (a-6) + (s-155260) )
    let (local bool_2190) = is_zero( (a-6) + (s-5900) )
    let (local bool_2191) = is_zero( (a-6) + (s-154900) )
    let (local bool_2192) = is_zero( (a-6) + (s-1690) )
    let (local bool_2193) = is_zero( (a-6) + (s-177480) )
    let (local bool_2194) = is_zero( (a-6) + (s-133800) )
    let (local bool_2195) = is_zero( (a-6) + (s-45370) )
    let (local bool_2196) = is_zero( (a-6) + (s-4200) )
    let (local bool_2197) = is_zero( (a-6) + (s-630) )
    let (local bool_2198) = is_zero( (a-6) + (s-680) )
    let (local bool_2199) = is_zero( (a-6) + (s-170) )
    let (local bool_2200) = is_zero( (a-6) + (s-133820) )
    let (local bool_2201) = is_zero( (a-6) + (s-136030) )
    let (local bool_2202) = is_zero( (a-6) + (s-45680) )
    let (local bool_2203) = is_zero( (a-6) + (s-71100) )
    let (local bool_2204) = is_zero( (a-6) + (s-24080) )
    let (local bool_2205) = is_zero( (a-6) + (s-26690) )
    let (local bool_2206) = is_zero( (a-6) + (s-133300) )
    let (local bool_2207) = is_zero( (a-6) + (s-4400) )
    let (local bool_2208) = is_zero( (a-6) + (s-157200) )
    let (local bool_2209) = is_zero( (a-6) + (s-23600) )
    let (local bool_2210) = is_zero( (a-6) + (s-28420) )
    let (local bool_2211) = is_zero( (a-6) + (s-133180) )
    let (local bool_2212) = is_zero( (a-6) + (s-134280) )
    let (local bool_2213) = is_zero( (a-6) + (s-134350) )
    let (local bool_2214) = is_zero( (a-6) + (s-47980) )
    let (local bool_2215) = is_zero( (a-6) + (s-4590) )
    let (local bool_2216) = is_zero( (a-6) + (s-157680) )
    let (local bool_2217) = is_zero( (a-6) + (s-48960) )
    let (local bool_2218) = is_zero( (a-6) + (s-2000) )
    let (local bool_2219) = is_zero( (a-6) + (s-28800) )
    let (local bool_2220) = is_zero( (a-6) + (s-131310) )
    let (local bool_2221) = is_zero( (a-6) + (s-47520) )
    let (local bool_2222) = is_zero( (a-6) + (s-113150) )
    let (local bool_2223) = is_zero( (a-6) + (s-24120) )
    let (local bool_2224) = is_zero( (a-6) + (s-157770) )
    let (local bool_2225) = is_zero( (a-6) + (s-45820) )
    let (local bool_2226) = is_zero( (a-6) + (s-157840) )
    let (local bool_2227) = is_zero( (a-6) + (s-72590) )
    let (local bool_2228) = is_zero( (a-6) + (s-137800) )
    let (local bool_2229) = is_zero( (a-6) + (s-176680) )
    let (local bool_2230) = is_zero( (a-6) + (s-89300) )
    let (local bool_2231) = is_zero( (a-6) + (s-72100) )
    let (local bool_2232) = is_zero( (a-6) + (s-70430) )
    let (local bool_2233) = is_zero( (a-6) + (s-4870) )
    let (local bool_2234) = is_zero( (a-6) + (s-28360) )
    let (local bool_2235) = is_zero( (a-6) + (s-67460) )
    let (local bool_2236) = is_zero( (a-6) + (s-700) )
    let (local bool_2237) = is_zero( (a-6) + (s-24190) )
    let (local bool_2238) = is_zero( (a-6) + (s-67780) )
    let (local bool_2239) = is_zero( (a-6) + (s-2100) )
    let (local bool_2240) = is_zero( (a-6) + (s-21930) )
    let (local bool_2241) = is_zero( (a-6) + (s-550) )
    let (local bool_2242) = is_zero( (a-6) + (s-24040) )
    let (local bool_2243) = is_zero( (a-6) + (s-4160) )
    let (local bool_2244) = is_zero( (a-6) + (s-67420) )
    let (local bool_2245) = is_zero( (a-6) + (s-137980) )
    let (local bool_2246) = is_zero( (a-6) + (s-67300) )
    let (local bool_2247) = is_zero( (a-6) + (s-111290) )
    let (local bool_2248) = is_zero( (a-6) + (s-131230) )
    let (local bool_2249) = is_zero( (a-6) + (s-131440) )
    let (local bool_2250) = is_zero( (a-6) + (s-132580) )
    let (local bool_2251) = is_zero( (a-6) + (s-6760) )
    let (local bool_2252) = is_zero( (a-6) + (s-190) )
    let (local bool_2253) = is_zero( (a-6) + (s-131410) )
    let (local bool_2254) = is_zero( (a-6) + (s-72280) )
    let (local bool_2255) = is_zero( (a-6) + (s-25730) )
    tempvar sop = bool_1974 * 99 + bool_1975 * 49 + bool_1976 * 99 + bool_1977 * 99 + bool_1978 * 49 + bool_1979 * 99 + bool_1980 * 99 + bool_1981 * 99 + bool_1982 * 99 + bool_1983 * 99 + bool_1984 * 99 + bool_1985 * 149 + bool_1986 * 99 + bool_1987 * 99 + bool_1988 * 99 + bool_1989 * 99 + bool_1990 * 99 + bool_1991 * 99 + bool_1992 * 99 + bool_1993 * 99 + bool_1994 * 99 + bool_1995 * 99 + bool_1996 * 99 + bool_1997 * 49 + bool_1998 * 99 + bool_1999 * 99 + bool_2000 * 99 + bool_2001 * 167 + bool_2002 * 99 + bool_2003 * 99 + bool_2004 * 12 + bool_2005 * 99 + bool_2006 * 49 + bool_2007 * 12 + bool_2008 * 99 + bool_2009 * 99 + bool_2010 * 6 + bool_2011 * 99 + bool_2012 * 49 + bool_2013 * 99 + bool_2014 * 49 + bool_2015 * 99 + bool_2016 * 99 + bool_2017 * 99 + bool_2018 * 15 + bool_2019 * 99 + bool_2020 * 180 + bool_2021 * 24 + bool_2022 * 44 + bool_2023 * 49 + bool_2024 * 99 + bool_2025 * 49 + bool_2026 * 99 + bool_2027 * 99 + bool_2028 * 99 + bool_2029 * 49 + bool_2030 * 3 + bool_2031 * 49 + bool_2032 * 99 + bool_2033 * 24 + bool_2034 * 49 + bool_2035 * 12 + bool_2036 * 99 + bool_2037 * 99 + bool_2038 * 4 + bool_2039 * 24 + bool_2040 * 99 + bool_2041 * 99 + bool_2042 * 99 + bool_2043 * 49 + bool_2044 * 99 + bool_2045 * 24 + bool_2046 * 3 + bool_2047 * 99 + bool_2048 * 99 + bool_2049 * 49 + bool_2050 * 49 + bool_2051 * 99 + bool_2052 * 99 + bool_2053 * 99 + bool_2054 * 99 + bool_2055 * 49 + bool_2056 * 99 + bool_2057 * 49 + bool_2058 * 99 + bool_2059 * 49 + bool_2060 * 99 + bool_2061 * 49 + bool_2062 * 99 + bool_2063 * 49 + bool_2064 * 99 + bool_2065 * 99 + bool_2066 * 99 + bool_2067 * 49 + bool_2068 * 99 + bool_2069 * 99 + bool_2070 * 99 + bool_2071 * 99 + bool_2072 * 99 + bool_2073 * 99 + bool_2074 * 99 + bool_2075 * 99 + bool_2076 * 24 + bool_2077 * 49 + bool_2078 * 99 + bool_2079 * 99 + bool_2080 * 99 + bool_2081 * 99 + bool_2082 * 99 + bool_2083 * 100 + bool_2084 * 99 + bool_2085 * 99 + bool_2086 * 99 + bool_2087 * 99 + bool_2088 * 99 + bool_2089 * 99 + bool_2090 * 99 + bool_2091 * 99 + bool_2092 * 99 + bool_2093 * 99 + bool_2094 * 99 + bool_2095 * 99 + bool_2096 * 99 + bool_2097 * 99 + bool_2098 * 99 + bool_2099 * 99 + bool_2100 * 99 + bool_2101 * 99 + bool_2102 * 99 + bool_2103 * 99 + bool_2104 * 99 + bool_2105 * 99 + bool_2106 * 49 + bool_2107 * 99 + bool_2108 * 99 + bool_2109 * 49 + bool_2110 * 99 + bool_2111 * 99 + bool_2112 * 99 + bool_2113 * 99 + bool_2114 * 99 + bool_2115 * 99 + bool_2116 * 99 + bool_2117 * 99 + bool_2118 * 99 + bool_2119 * 24 + bool_2120 * 49 + bool_2121 * 49 + bool_2122 * 0 + bool_2123 * 99 + bool_2124 * 24 + bool_2125 * 49 + bool_2126 * 99 + bool_2127 * 49 + bool_2128 * 99 + bool_2129 * 49 + bool_2130 * 49 + bool_2131 * 99 + bool_2132 * 49 + bool_2133 * 49 + bool_2134 * 99 + bool_2135 * 99 + bool_2136 * 49 + bool_2137 * 176 + bool_2138 * 99 + bool_2139 * 99 + bool_2140 * 99 + bool_2141 * 99 + bool_2142 * 99 + bool_2143 * 49 + bool_2144 * 99 + bool_2145 * 99 + bool_2146 * 99 + bool_2147 * 49 + bool_2148 * 99 + bool_2149 * 149 + bool_2150 * 24 + bool_2151 * 99 + bool_2152 * 99 + bool_2153 * 99 + bool_2154 * 99 + bool_2155 * 49 + bool_2156 * 99 + bool_2157 * 99 + bool_2158 * 49 + bool_2159 * 99 + bool_2160 * 99 + bool_2161 * 99 + bool_2162 * 99 + bool_2163 * 49 + bool_2164 * 99 + bool_2165 * 99 + bool_2166 * 99 + bool_2167 * 99 + bool_2168 * 99 + bool_2169 * 60 + bool_2170 * 99 + bool_2171 * 99 + bool_2172 * 100 + bool_2173 * 49 + bool_2174 * 99 + bool_2175 * 99 + bool_2176 * 49 + bool_2177 * 99 + bool_2178 * 99 + bool_2179 * 49 + bool_2180 * 99 + bool_2181 * 49 + bool_2182 * 99 + bool_2183 * 99 + bool_2184 * 24 + bool_2185 * 99 + bool_2186 * 99 + bool_2187 * 24 + bool_2188 * 49 + bool_2189 * 49 + bool_2190 * 99 + bool_2191 * 49 + bool_2192 * 49 + bool_2193 * 99 + bool_2194 * 99 + bool_2195 * 49 + bool_2196 * 49 + bool_2197 * 99 + bool_2198 * 99 + bool_2199 * 99 + bool_2200 * 99 + bool_2201 * 99 + bool_2202 * 49 + bool_2203 * 49 + bool_2204 * 99 + bool_2205 * 99 + bool_2206 * 99 + bool_2207 * 49 + bool_2208 * 49 + bool_2209 * 99 + bool_2210 * 99 + bool_2211 * 99 + bool_2212 * 99 + bool_2213 * 99 + bool_2214 * 99 + bool_2215 * 99 + bool_2216 * 49 + bool_2217 * 99 + bool_2218 * 99 + bool_2219 * 99 + bool_2220 * 160 + bool_2221 * 99 + bool_2222 * 99 + bool_2223 * 49 + bool_2224 * 49 + bool_2225 * 99 + bool_2226 * 99 + bool_2227 * 99 + bool_2228 * 99 + bool_2229 * 24 + bool_2230 * 149 + bool_2231 * 49 + bool_2232 * 99 + bool_2233 * 99 + bool_2234 * 99 + bool_2235 * 99 + bool_2236 * 99 + bool_2237 * 49 + bool_2238 * 49 + bool_2239 * 99 + bool_2240 * 99 + bool_2241 * 99 + bool_2242 * 49 + bool_2243 * 99 + bool_2244 * 186 + bool_2245 * 149 + bool_2246 * 49 + bool_2247 * 99 + bool_2248 * 99 + bool_2249 * 49 + bool_2250 * 99 + bool_2251 * 99 + bool_2252 * 99 + bool_2253 * 49 + bool_2254 * 49 + bool_2255 * 49
    return (result=sop)
end
