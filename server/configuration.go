package main

import "encoding/json"

type Configuration struct {
	GuardsJSON string
}

type ConfigGuard struct {
	TeamName    string
	ChannelName string
	Allowed     []string
}

// OnConfigurationChange is invoked when configuration changes may have been made.
func (p *guard) OnConfigurationChange() error {
	var c Configuration

	if err := p.API.LoadPluginConfiguration(&c); err != nil {
		p.API.LogError(err.Error())
		return err
	}

	var guards []*ConfigGuard
	if c.GuardsJSON != "" {
		if err := json.Unmarshal([]byte(c.GuardsJSON), &guards); err != nil {
			p.API.LogError("Failed to parse GuardsJSON", "err", err.Error())
			return err
		}
	}

	p.guards.Store(guards)

	return nil
}

func (p *guard) getGuards() []*ConfigGuard {
	return p.guards.Load().([]*ConfigGuard)
}
